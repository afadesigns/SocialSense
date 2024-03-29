import re
from re import Pattern
from typing import Callable, List

from mkdocs.plugins import BasePlugin
from mkdocs.structure.nav import Page

REPLACE_TYPE_ALIAS = "type_alias"
SENTINEL_VALUE = "<_Sentinel.A: 0>"

REPLACE_FUNCS: List[ReplaceFunc] = [
    regex_replace(
        re.compile(
            r"Union\[([][\w, ]+, ([][\w, ]+)), instagrapi\._interaction\._Sentinel]"
        ),
        r"Possible[Union[\1]]",
    ),
    regex_replace(
        re.compile(r"Union\[([][\w, ]+), instagrapi\._interaction\._Sentinel]"),
        r"Possible[\1]",
    ),
    regex_replace(
        re.compile(
            r"Union\[(\w+), Callable\[\[Mapping\[str, Union\[bool, str]]], \w+]]"
        ),
        r"StaticOrDynamicValue[\1]",
    ),
    regex_replace(
        re.compile(
            r"Union\[([][\w]+), Callable\[\[Mapping\[str, Union\[bool, str]]], [][\w]+]]"
        ),
        r"StaticOrDynamicValue[\1]]",
    ),
    simple_replace("Callable[[Mapping[str, Union[bool, str]]], bool]", "ShouldAsk"),
    simple_replace(
        "Callable[[str, Mapping[str, Union[bool, str]]], Optional[str]]", "Validator"
    ),
    simple_replace("Union[Echo, Acknowledge, Question]", "Interaction"),
    simple_replace("Mapping[str, Union[bool, str]]", "Answers"),
    simple_replace("[List[str]]", "[OptionList]"),
    regex_replace(re.compile(r"Union\[(\w+), NoneType]"), r"Optional[\1]"),
    simple_replace(SENTINEL_VALUE, "_Sentinel"),
]


ReplaceFunc = Callable[[str], str]
"""A function that takes a string and returns a replaced string.

Used for replacing type aliases in the documentation.
"""


def simple_replace(look_for: str, replace_with: str) -> ReplaceFunc:
    def _replace(text: str) -> str:
        return text.replace(look_for, replace_with)

    return _replace


def regex_replace(look_for: Pattern, replace_with: str) -> ReplaceFunc:
    def _replace(text: str) -> str:
        return re.sub(look_for, replace_with, text)

    return _replace


class PatchTypeAliases(BasePlugin):
    """
    Manually put type aliases back into documentation.

    mkdocstrings shows the actual type instead of the type alias.
    https://github.com/pawamoy/pytkdocs/issues/80
    """

    def on_post_page(self, output: str, page: Page, config: dict) -> str:
        if page.title == "Reference":
            for replace in REPLACE_FUNCS:
                output = replace(output)
        return output


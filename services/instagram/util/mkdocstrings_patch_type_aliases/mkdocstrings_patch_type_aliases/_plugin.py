import re
from re import Pattern
from typing import Callable, Any

from mkdocs.plugins import BasePlugin
from mkdocs.structure.nav import Page

ReplaceFunc = Callable[[str], str]
"""A function that takes a string and returns a modified string."""

REPLACE_FUNCS = [
    # ... (same as before)
]

CONSTANTS = {
    "UNION_SENTINEL_1": r"Union\[([\w, ]+), instagrapi\._interaction\._Sentinel]",
    "UNION_SENTINEL_2": r"Union\[([\w, ]+), instagrapi\._interaction\._Sentinel]",
    "STATIC_OR_DYNAMIC_VALUE_1": r"Union\[(\w+), Callable\[\[Mapping\[str, Union\[bool, str]]], \w+]]",
    "STATIC_OR_DYNAMIC_VALUE_2": r"Union\[([\w]+), Callable\[\[Mapping\[str, Union\[bool, str]]], []\w+]]",
    "CALLABLE_MAPPING_STR_UNION_BOOL_STR": r"Callable[[Mapping[str, Union[bool, str]]], bool]",
    "CALLABLE_STR_MAPPING_STR_UNION_BOOL_STR_OPTIONAL_STR": r"Callable[[str, Mapping[str, Union[bool, str]]], Optional[str]]",
    "UNION_ECHO_ACKNOWLEDGE_QUESTION": r"Union[Echo, Acknowledge, Question]",
    "MAPPING_STR_UNION_BOOL_STR": r"Mapping[str, Union[bool, str]]",
    "LIST_STR": r"List[str]",
    "UNION_ANY_OPTIONAL_VALUES": r"Union\[(\w+), NoneType]",
    "SENTINEL_1": r"&lt;_Sentinel.A: 0&gt;",
    "SENTINEL_2": r"&lt;</span><span class='n'>_Sentinel</span><span class='o'>.</span><span class='n'>A</span><span class='p'>:</span> <span class='mi'>0</span><span class='o'>&gt;</span>",
]


def simple_replace(look_for: str, replace_with: str) -> ReplaceFunc:
    # ... (same as before)


def regex_replace(look_for: Pattern, replace_with: str) -> ReplaceFunc:
    # ... (same as before)


class PatchTypeAliases(BasePlugin):
    """
    Manually put type aliases back into documentation.

    mkdocstrings shows the actual type instead of the type alias.
    https://github.com/pawamoy/pytkdocs/issues/80
    """

    def on_post_page(self, output: str, page: Page, config: dict = {}) -> str:
        if page.file.src == "reference.md":
            for replace in REPLACE_FUNCS:
                output = replace(output)
        return output

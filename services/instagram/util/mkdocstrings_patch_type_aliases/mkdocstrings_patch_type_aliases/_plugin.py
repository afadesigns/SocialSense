import functools
import re
from re import Pattern
from typing import AnyStr, Callable, List, TypeVar

from mkdocs.plugins import BasePlugin
from mkdocs.structure.nav import Page

T = TypeVar('T')


def simple_replace(look_for: str, replace_with: str) -> Callable[[T], T]:
    return functools.partial(str.replace, look_for, replace_with)


def regex_replace(look_for: Pattern, replace_with: str) -> Callable[[T], T]:
    return functools.partial(re.sub, look_for, replace_with)


def apply_replace_funcs(text: str, replace_funcs: List[Callable[[str], str]]) -> str:
    for replace in replace_funcs:
        text = replace(text)
    return text


REPLACE_FUNCS = [
    regex_replace(
        re.compile(
            r"Union\["
            rf"({re.escape(r'[\w, ]+')}), "
            rf"({re.escape(r'[\w, ]+')}), "
            r"instagrapi\._interaction\._Sentinel"
            r"]"
        ),
        r"Possible[Union[\1]]",
    ),
    # ... other replace functions ...
]


class PatchTypeAliases(BasePlugin):
    """
    Manually put type aliases back into documentation.

    mkdocstrings shows the actual type instead of the type alias.
    https://github.com/pawamoy/pytkdocs/issues/80
    """

    def __init__(self) -> None:
        super().__init__(name='patch_type_aliases')

    def on_post_page(self, output: str, page: Page, config: dict) -> str:
        if page.title == "Reference":
            output = apply_replace_funcs(output, REPLACE_FUNCS)
        return output

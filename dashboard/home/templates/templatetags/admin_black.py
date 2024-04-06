# -*- encoding: utf-8 -*-
"""
Copyright (c) 2019 - present AppSeed.us
"""

import re
from typing import Dict, Any, Union, Optional

from django import template
from django.utils.html import format_html
from django.utils.safestring import mark_safe
from django.contrib.admin.views.main import PAGE_VAR
from admin_black_pro.utils import get_menu_items

register = template.Library()
assignment_tag = (
    register.assignment_tag
    if hasattr(register, "assignment_tag")
    else register.simple_tag
)


@register.filter
def clean_text(value: str) -> str:
    """
    Remove newline characters from a string.
    """
    res = value.replace("\n", " ")
    return res


@register.filter
def checkbox(value: str) -> str:
    """
    Remove table cells and table data tags from a string.
    """
    res = re.sub(r"</?(?i:td)(.|\n)*?>", "", value) if value else ""
    return res


@assignment_tag(takes_context=True)
def admin_get_menu(context: dict) -> Dict[str, Any]:
    """
    Return menu items for the admin panel.
    """
    return get_menu_items(context)


@assignment_tag(takes_context=True)
def get_direction(context: dict) -> Dict[str, str]:
    """
    Return a dictionary with CSS classes based on the text direction.
    """
    res = {
        "panel": "text-left",
        "notify": "right",
        "float": "float-right",
        "reverse_panel": "text-right",
        "nav": "ml-auto",
    }

    if context.get("LANGUAGE_BIDI"):
        res["panel"] = "text-right"
        res["notify"] = "left"
        res["float"] = ""
        res["reverse_panel"] = "text-left"
        res["nav"] = "mr-auto"
    return res


@assignment_tag(takes_context=True)
def get_admin_setting(context: dict) -> Dict[str, Optional[str]]:
    """
    Return a dictionary with admin settings.
    """
    # user = context.get('request').user
    # admin_black_setting = user.admin_black_setting if hasattr(user, 'admin_black_setting') else None
    res = {
        # 'sidebar_background': admin_black_setting.sidebar_background if admin_black_setting else 'primary',
        # 'dark_mode': admin_black_setting.dark_mode if admin_black_setting else True,
        # 'input_bg_color': '#ffffff' if admin_black_setting and not admin_black_setting.dark_mode else '#27293c'
    }

    return res


@register.simple_tag
def paginator_number(cl: template.Context, i: Union[int, str]) -> str:
    """
    Generate an individual page index link in a paginated list.
    """
    if i == cl.paginator.ELLIPSIS:
        return format_html("{} ", cl.paginator.ELLIPSIS)
    elif isinstance(cl.page_num, int) and i == cl.page_num:
        return format_html('<a href="" class="page-link">{}</a> ', i)
    elif isinstance(i, int) and 1 <= i <= cl.paginator.num_pages

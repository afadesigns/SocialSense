# -*- encoding: utf-8 -*-
"""
Copyright (c) 2019 - present AppSeed.us
"""

import datetime
import json
from typing import Any, Dict, List, Optional

import django
from django.apps import apps
from django.contrib import admin, messages
from django.contrib.admin.options import IncorrectLookupParameters
from django.contrib.auth.decorators import login_required
from django.core.exceptions import ImproperlyConfigured, PermissionDenied
from django.core.serializers.json import DjangoJSONEncoder
from django.db import router
from django.http import HttpResponse
from django.shortcuts import render
from django.urls import reverse, resolve, NoReverseMatch
from django.utils import six, text
from django.utils.decorators import method_decorator
from django.utils.html import format_html
from django.utils.text import capfirst, slugify
from django.utils.translation import ugettext_lazy as _

try:
    from collections import OrderedDict
except ImportError:
    from ordereddict import OrderedDict  # Python 2.6


default_apps_icon = {"auth": "icon-lock-circle"}


class JsonResponse(HttpResponse):
    """
    An HTTP response class that consumes data to be serialized to JSON.
    """

    def __init__(
        self,
        data: Any,
        encoder: Optional[DjangoJSONEncoder] = None,
        safe: bool = True,
        **kwargs: Any,
    ):
        if safe and not isinstance(data, dict):
            raise TypeError(
                "In order to allow non-dict objects to be "
                "serialized set the safe parameter to False"
            )
        kwargs.setdefault("content_type", "application/json")
        data = json.dumps(data, cls=encoder)
        super(JsonResponse, self).__init__(content=data, **kwargs)


@method_decorator(login_required, name="dispatch")
class SuccessMessageMixin:
    """
    Adds a success message on successful form submission.
    """

    success_message = ""

    def form_valid(self, form):
        response = super().form_valid(form)
        success_message = self.get_success_message(form.cleaned_data)
        if success_message:
            messages.success(self.request, success_message)
        return response

    def get_success_message(self, cleaned_data):
        return self.success_message % cleaned_data


def get_app_list(context, order: bool = True) -> List[Dict[str, Any]]:
    admin_site = get_admin_site(context)
    request = context["request"]

    app_dict = {}
    for model, model_admin in admin_site._registry.items():

        app_icon = (
            model._meta.app_config.icon
            if hasattr(model._meta.app_config, "icon")
            else None
        )
        app_label = model._meta.app_label
        try:
            has_module_perms = model_admin.has_module_permission(request)
        except AttributeError:
            has_module_perms = request.user.has_module_perms(
                app_label
            )  # Fix Django < 1.8 issue

        if has_module_perms:
            perms = model_admin.get_model_perms(request)

            # Check whether user has any perm for this module.
            # If so, add the module to the model_list.
            if True in perms.values():
                info = (app_label, model._meta.model_name)
                model_dict = {
                    "name": capfirst(model._meta.verbose_name_plural),
                    "object_name": model._meta.object_name,
                    "perms": perms,
                    "model_name": model._meta.model_name,
                }
                if perms.get("change", False) or perms.get("view", False):
                    try:
                        model_dict["admin_url"] = reverse(
                            "admin:%s_%s_changelist" % info, current_app=admin_site.name
                        )
                    except NoReverseMatch:
                        pass
                if perms.get("add", False):
                    try:
                        model_dict["add_url"] = reverse(
                            "admin:%s_%s_add" % info, current_app=admin_site.name
                        )
                    except NoReverseMatch:
                        pass
                if app_label in app_dict:
                    app_dict[app_label]["models"].append(model_dict)
                else:
                    try:
                        name = apps.get_app_config(app_label).verbose_name
                    except NameError:
                        name = app_label.title()
                    app_dict[app_label] = {
                        "name": name,
                        "app_label": app_label,
                        "app_url": reverse(
                            "admin:app_list",
                            kwargs={"app_label": app_label},
                            current_app=admin_site.name,
                        ),
                        "has_module_perms": has_module_perms,
                        "models": [model_dict],
                    }

                if not app_icon:
                    app_icon = (
                        default_apps_icon[app_label]
                        if app_label in default_apps_icon
                        else None
                

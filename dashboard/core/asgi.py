# C:\Users\Andreas\Projects\SocialSense\dashboard\core\asgi.py

"""
ASGI config for core project.

This module serves as the ASGI configuration for the core Django project.
It exposes the ASGI callable as a module-level variable named ``application``.

For more information on ASGI and its usage in Django, see:
https://docs.djangoproject.com/en/4.1/howto/deployment/asgi/
"""

import os

from django.core.asgi import get_asgi_application

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "core.settings")

application = get_asgi_application()

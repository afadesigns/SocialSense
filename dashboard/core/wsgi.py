# C:\Users\Andreas\Projects\SocialSense\dashboard\core\wsgi.py

"""
WSGI config for core project.

This module exposes the WSGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/4.1/howto/deployment/wsgi/
"""

import os

from django.core.wsgi import get_wsgi_application

# Set the DJANGO_SETTINGS_MODULE environment variable to core.settings
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "core.settings")

# Get the WSGI application
wsgi_application = get_wsgi_application()

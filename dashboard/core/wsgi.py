# C:\Users\Andreas\Projects\SocialSense\dashboard\core\wsgi.py

"""
WSGI config for core project.

It exposes the WSGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/4.1/howto/deployment/wsgi/
"""

import os

from django.core.wsgi import get_wsgi_application

# Set the DJANGO_SETTINGS_MODULE environment variable to specify the settings module for the WSGI application.
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "core.settings")

# Create a WSGI application instance using Django's get_wsgi_application function.
application = get_wsgi_application()

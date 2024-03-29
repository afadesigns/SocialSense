"""
ASGI configuration for the Django project.

This module exposes the ASGI callable as a module-level variable named `application`.

For more information, see:
https://docs.djangoproject.com/en/4.1/howto/deployment/asgi/
"""

import os

# Import the Django ASGI application.
from django.core.asgi import get_asgi_application

# Import the routing configuration for the WebSocket protocol.
from your_app.routing import websocket_urlpatterns

# Set the default value for the DJANGO_SETTINGS_MODULE environment variable.
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "core.settings")

# Create an instance of the ASGI application router.
application = ProtocolTypeRouter({
    # Configure the HTTP/HTTPS protocol to use the Django ASGI application.
    "http": get_asgi_application(),
    # Configure the WebSocket protocol to use the authentication middleware
    # and the routing configuration for the `your_app` application.
    "websocket": AuthMiddlewareStack(
        URLRouter(
            websocket_urlpatterns
        )
    ),
})

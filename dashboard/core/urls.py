# C:\\Users\\Andreas\\Projects\\SocialSense\\dashboard\\core\\urls.py

from django.conf import settings
from django.conf.urls.static import static
from django.contrib import admin
from django.urls import (
    include,
    path,
    path as url_path,
)  # Import path as url_path for clarity

urlpatterns = [
    *(
        [
            url_path("__debug__/", include("debug_toolbar.urls"))
        ]  # Include Debug Toolbar URLs only in development mode
        if settings.DEBUG
        else []
    ),
    path("", include("home.urls")),  # Include home URLs
    path("admin/", admin.site.urls),  # Include Django admin URLs
    path("", include("admin_black_pro.urls")),  # Include admin_black_pro URLs
] + static(
    settings.MEDIA_URL, document_root=settings.MEDIA_ROOT
)  # Serve media files in development mode

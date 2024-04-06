# C:\Users\Andreas\Projects\SocialSense\dashboard\core\urls.py

from django.urls import path, include
from dashboard.home.views import instagram_profile

urlpatterns = [
    # Include other existing URL patterns here
    path('', include('home.urls')),
    path("admin/", admin.site.urls),
    path("", include('admin_black_pro.urls')),
    
    # New URL pattern for the instagram_profile view
    path('instagram/profile/', instagram_profile, name='instagram-profile'),
]

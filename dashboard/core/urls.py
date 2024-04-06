<<<<<<< HEAD
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
=======
"""Core URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    
>>>>>>> 253105264d5cd49cfadfc83b0a7ab8b7f4f637c1

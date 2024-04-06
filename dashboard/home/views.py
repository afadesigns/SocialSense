# dashboard/home/views.py

from django.shortcuts import render
from instagrapi import Client
from django.conf import settings

def instagram_profile(request):
    # Create instagrapi client instance
    cl = Client()
    # Login using Instagram credentials
    cl.login(username=settings.INSTAGRAM_USERNAME, password=settings.INSTAGRAM_PASSWORD)
    # Fetch profile info
    user_info = cl.user_info_by_username(settings.INSTAGRAM_USERNAME)
    
    context = {
        'user_info': user_info.dict(),
    }
    # Render the template with profile info
    return render(request, 'instagram/profile.html', context)

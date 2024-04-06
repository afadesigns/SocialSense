# dashboard/home/views.py

from django.shortcuts import render
from instagrapi import Client
from django.conf import settings

<<<<<<< HEAD
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
=======
# Create your views here.

def index(request):
    """
    This view function renders the dashboard page.
    Add any view-specific logic here before rendering the template.
    """
    # Page from the theme 
    context = {
        'sample_data': 'This is a sample data point.'
    }
    return render(request, 'pages/dashboard.html', context)

>>>>>>> 253105264d5cd49cfadfc83b0a7ab8b7f4f637c1

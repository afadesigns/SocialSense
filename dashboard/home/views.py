from django.contrib.auth.decorators import login_required
from django.shortcuts import render

from .models import UserProfile


@login_required
def index(request):
    user = request.user

    # Fetch the user's profile instance to access Instagram credentials
    try:
        profile = UserProfile.objects.get(user=user)
    except UserProfile.DoesNotExist:
        # Handle cases where the profile does not exist
        profile = None
        # Optionally, redirect to a page to complete profile setup
        # or simply add error handling logic here

    if profile:
        # Access Instagram credentials from the UserProfile instance
        instagram_username = profile.instagram_username
        instagram_password = profile.instagram_password
        # Logic to use InstagramService with these credentials
        # ...
        context = {
            # Add context data here
        }
    else:
        context = {"error": "UserProfile does not exist for the current user."}

    return render(request, "dashboard/home/index.html", context)

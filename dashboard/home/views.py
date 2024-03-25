from django.contrib.auth.decorators import login_required
from django.shortcuts import render

from .models import UserProfile  # Ensure this import is correct


@login_required
def index(request):
    user = request.user

    # Attempt to fetch the UserProfile instance associated with the current user
    try:
        profile = UserProfile.objects.get(user=user)
    except UserProfile.DoesNotExist:
        # Handle the case where the UserProfile does not exist
        context = {"error": "UserProfile does not exist for the current user."}
        return render(request, "dashboard/home/index.html", context)

    # Use the instagram_username and instagram_password from the UserProfile
    instagram_username = profile.instagram_username
    instagram_password = profile.instagram_password

    # Your logic to utilize the Instagram credentials follows here
    # For example, initializing an InstagramService instance with these credentials

    # Prepare your context data for rendering
    context = {
        # Include any context data here
    }

    return render(request, "dashboard/home/index.html", context)

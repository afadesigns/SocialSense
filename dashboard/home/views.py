from django.contrib.auth.decorators import login_required
from django.shortcuts import render

from .models import UserProfile


@login_required
def index(request):
    user = request.user

    try:
        # Attempt to fetch the associated UserProfile
        user_profile = UserProfile.objects.get(user=user)
    except UserProfile.DoesNotExist:
        # Handle the case where the UserProfile does not exist
        return render(request, "errors/user_profile_not_found.html", status=404)

    # Now, use instagram_username and instagram_password from user_profile
    instagram_username = user_profile.instagram_username
    instagram_password = user_profile.instagram_password

    # Continue with your logic using instagram_username and instagram_password
    # For example, initializing an InstagramService instance with these credentials

    context = {
        # Add any additional context data here
    }

    return render(request, "dashboard/home/index.html", context)

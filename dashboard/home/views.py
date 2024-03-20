from django.shortcuts import render
from django.contrib.auth.decorators import login_required

# Import the InstagramService
from services.instagram.instagram_service import InstagramService


@login_required
def index(request):
    """
    View function for the dashboard index page.
    """
    user = request.user

    # Placeholder for Instagram credentials - ensure you handle this securely
    instagram_username = user.instagram_username
    instagram_password = user.instagram_password

    # Initialize the InstagramService with the user's credentials
    instagram_service = InstagramService(instagram_username, instagram_password)

    # Initialize context with an error message in case Instagram data cannot be fetched
    context = {"instagram_error": "Could not fetch Instagram data."}

    if instagram_service.is_authenticated:
        # Fetch profile data and recent media
        profile_data = instagram_service.fetch_profile_data()
        recent_media = instagram_service.fetch_recent_media()

        # Update the context with Instagram data
        context = {
            "profile_data": profile_data,
            "recent_media": recent_media,
            "instagram_error": "",  # Clear the error message if data is fetched successfully
        }

    return render(request, "dashboard/home/index.html", context)

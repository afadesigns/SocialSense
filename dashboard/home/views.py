from django.contrib.auth.decorators import login_required
from django.shortcuts import render

from services.instagram.instagram_service import InstagramService


@login_required
def index(request):
    user = request.user

    # Initialize the InstagramService with user's Instagram credentials
    instagram_service = InstagramService(
        user.instagram_username, user.instagram_password
    )
    context = {"instagram_error": "Could not fetch Instagram data."}

    if instagram_service.is_authenticated:
        # Fetch profile data and recent media
        profile_data = instagram_service.fetch_profile_data()
        recent_media = instagram_service.fetch_recent_media()

        # Fetch additional insights data
        insights_data = (
            instagram_service.fetch_insights()
        )  # Assuming this method fetches comprehensive insights

        # Prepare additional insights for visualization
        # Here you can process the insights data further if necessary, e.g., aggregating data for chart visualization

        # Update context with all fetched data
        context = {
            "profile_data": profile_data,
            "recent_media": recent_media,
            "insights_data": insights_data,  # Include insights data in the context
            "instagram_error": "",  # Clear the error message upon successful data fetch
        }

    return render(request, "dashboard/home/index.html", context)

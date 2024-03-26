# path/to/views.py

import json

from django.contrib.auth.decorators import login_required
from django.shortcuts import render
from django.urls import path

# Correcting the import path for InstagramService based on the updated PYTHONPATH
from services.instagram.instagram_service import InstagramService


@login_required
def index(request):
    user = request.user

    # Initialize InstagramService with the user's Instagram credentials
    instagram_service = InstagramService(
        user.instagram_username, user.instagram_password
    )
    context = {"instagram_error": "Could not fetch Instagram data."}

    if instagram_service.is_authenticated:
        # Fetch profile data and recent media
        profile_data = instagram_service.fetch_profile_data()
        recent_media = instagram_service.fetch_recent_media()

        # Fix unresolved attribute reference for 'fetch_insights'
        insights_data = (
            instagram_service.fetch_insights()
        )  # Assuming comprehensive insights fetching is implemented

        # Data Processing for Visualization
        if "engagement_data" in insights_data:
            labels = [data["date"] for data in insights_data["engagement_data"]]
            engagement_rates = [
                data["engagement_rate"] for data in insights_data["engagement_data"]
            ]

            processed_insights = {
                "labels": labels,
                "datasets": [
                    {
                        "label": "Engagement Rate",
                        "data": engagement_rates,
                        "fill": False,
                        "borderColor": "rgb(75, 192, 192)",
                        "tension": 0.1,
                    }
                ],
            }
            context["processed_insights"] = json.dumps(processed_insights)
        else:
            context["processed_insights"] = json.dumps({})

        context.update(
            {
                "profile_data": profile_data,
                "recent_media": recent_media,
                "instagram_error": "",  # Clear error message upon successful data fetch
            }
        )

    return render(request, "dashboard/home/index.html", context)


# Define a placeholder fetch_bio_link function
# Parameter 'bio_link_id' value is not used; Parameter 'request' value is not used
def fetch_bio_link(request, bio_link_id):
    # Placeholder implementation
    # Replace this with actual functionality
    pass


# URL patterns definition
urlpatterns = [
    path("", index, name="home-index"),
    # Add other URL patterns here as needed
]

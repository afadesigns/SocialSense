import os
import sys

# Calculate the directory path that's two levels up from this file
PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))

# Append the PROJECT_ROOT to sys.path
if PROJECT_ROOT not in sys.path:
    sys.path.append(PROJECT_ROOT)

# Now Python should be able to resolve imports from the SocialSense root directory


import json

from django.contrib.auth.decorators import login_required
from django.shortcuts import render


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

        # Fetch insights data
        insights_data = instagram_service.fetch_insights()  # Comprehensive insights

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
def fetch_bio_link(request, bio_link_id):
    # Placeholder implementation
    # Replace this with actual functionality
    pass

import json

from django.contrib.auth.decorators import login_required
from django.shortcuts import render

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

        # Fetch insights data
        insights_data = instagram_service.fetch_insights()  # Comprehensive insights

        # Data Processing for Visualization
        # Example: Process engagement rate data
        if "engagement_data" in insights_data:
            labels = [data["date"] for data in insights_data["engagement_data"]]
            engagement_rates = [
                data["engagement_rate"] for data in insights_data["engagement_data"]
            ]

            # Structuring data for Chart.js
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
            # Convert to JSON for JavaScript consumption in the template
            context["processed_insights"] = json.dumps(processed_insights)
        else:
            # Handle the case where engagement data is not available
            context["processed_insights"] = json.dumps({})

        # Update context with all fetched and processed data
        context.update(
            {
                "profile_data": profile_data,
                "recent_media": recent_media,
                "instagram_error": "",  # Clear error message upon successful data fetch
            }
        )

    return render(request, "dashboard/home/index.html", context)

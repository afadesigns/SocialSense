import json

from django.contrib.auth.decorators import login_required
from django.http import HttpResponse
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


def fetch_bio_link(request, bio_link_id):
    # Your logic to fetch bio link data based on bio_link_id
    bio_link_data = {
        "bio_link_id": bio_link_id,
        "title": "Bio Link Title",
        "url": "https://example.com",
    }
    # Convert bio link data to JSON
    bio_link_json = json.dumps(bio_link_data)
    # Return the JSON response
    return HttpResponse(bio_link_json, content_type="application/json")


def fetch_location(request, location_id):
    # Your logic to fetch location data based on location_id
    location_data = {
        "location_id": location_id,
        "name": "Location Name",
        "latitude": 123.456,  # Example latitude
        "longitude": 789.012,  # Example longitude
    }
    # Convert location data to JSON
    location_json = json.dumps(location_data)
    # Return the JSON response
    return HttpResponse(location_json, content_type="application/json")


# Define other view functions here for remaining URL patterns

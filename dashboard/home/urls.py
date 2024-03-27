from django.contrib.auth.decorators import login_required
from django.shortcuts import render
from django.urls import path


@login_required
def index(request):
    # user = request.user
    # Previously InstagramService initialization and usage removed
    context = {}

    # Removed Instagram data fetching logic to decouple Instagram from dashboard access
    # Your dashboard logic here, if any, that does not depend on Instagram

    return render(request, "dashboard/home/index.html", context)


# Keeping the placeholder function for fetch_bio_link if it's still needed
def fetch_bio_link(request, bio_link_id):
    # Placeholder implementation
    # Replace this with actual functionality if needed
    pass


# URL patterns definition remains unchanged
urlpatterns = [
    path("", index, name="home-index"),
    # Ensure other URL patterns do not depend on InstagramService for critical functionalities
]

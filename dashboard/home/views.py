# C:\Users\Andreas\Projects\SocialSense\dashboard\home\views.py

#  Copyright (c) 2024. Lorem ipsum dolor sit amet, consectetur adipiscing elit.
#  Morbi non lorem porttitor neque feugiat blandit. Ut vitae ipsum eget quam lacinia accumsan.
#  Etiam sed turpis ac ipsum condimentum fringilla. Maecenas magna.
#  Proin dapibus sapien vel ante. Aliquam erat volutpat. Pellentesque sagittis ligula eget metus.
#  Vestibulum commodo. Ut rhoncus gravida arcu.

# C:/Users/Andreas/Projects/SocialSense/dashboard/home/views.py

import logging

from django.contrib.auth.decorators import login_required
from django.shortcuts import render

from .instagram_api import (
    fetch_direct_messages,
    fetch_profile_data,
    fetch_recent_media,
    login_user,  # Add this line to import the login_user function
)

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


@login_required
def index(request):
    # Get authenticated user
    user = request.user

    # Initialize instagrapi client
    client = login_user(user.instagram_username, user.instagram_password)

    if client:
        # Fetch Instagram user profile data by passing the client instance
        profile_data = fetch_profile_data(client)

        # Fetch all recent media
        recent_media = fetch_recent_media(client)

        # Slice the list to get the desired number of recent media items
        recent_media = recent_media[:5]  # Fetch the first 5 recent media items

        # Example: Fetch direct message conversations
        direct_messages = fetch_direct_messages(client)

        # Pass data to template
        context = {
            "profile_data": profile_data,
            "recent_media": recent_media,
            "direct_messages": direct_messages,
        }

        # Render template with data
        return render(request, "pages/dashboard.html", context)
    else:
        # Handle login failure
        logger.error("Login failed. Please check your credentials.")
        return render(request, "pages/login_failed.html")


# These view functions correspond to the URL patterns defined in urls.py
@login_required
def fetch_user_bio_link(request, user_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_bio_link(request, bio_link_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_location(request, location_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_collection(request, collection_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_highlight(request, highlight_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_resource(request, resource_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_hashtag(request, hashtag_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_track(request, track_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_note(request, note_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_note_user(request, note_user_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_direct_message(request, dm_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_direct_message_user(request, dm_user_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_relationship_user(request, rel_user_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_direct_thread(request, thread_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_direct_thread_user(request, dt_user_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_relationship(request, relationship_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_story(request, story_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_story_user(request, story_user_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_story_hashtag(request, story_hashtag_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_story_link(request, story_link_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_story_highlight(request, story_highlight_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_story_mention(request, story_mention_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_constants(request, constants_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_story_location(request, story_location_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_story_sticker(request, story_sticker_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_direct_message_thread(request, dm_thread_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_media(request, media_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_user_media(request, user_media_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_highlight_media(request, highlight_media_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_media_resource(request, media_resource_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_comment(request, comment_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_story_comment(request, story_comment_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_usertag(request, usertag_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_media_usertag(request, media_usertag_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_media_sponsor(request, media_sponsor_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_media_comment(request, media_comment_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_media_location(request, media_location_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_media_story(request, media_story_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_media_hashtag(request, media_hashtag_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_story_usertag(request, story_usertag_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_story_location(request, story_location_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_story_sticker(request, story_sticker_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_comment_reply(request, comment_reply_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass


@login_required
def fetch_comment_mention(request, comment_mention_id):
    """
    This view function is intentionally left empty because it is not yet implemented.
    """
    pass

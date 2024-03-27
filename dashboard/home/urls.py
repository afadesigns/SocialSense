# C:/Users/Andreas/Projects/SocialSense/dashboard/home/urls.py

from django.urls import path

from . import views

urlpatterns = [
    path("", views.index, name="index"),  # Default index route
    path(
        "user_bio_link/<str:user_id>/",
        views.fetch_user_bio_link,
        name="user_bio_link",
    ),
    path("bio_link/<str:bio_link_id>/", views.fetch_bio_link, name="bio_link"),
    path("location/<str:location_id>/", views.fetch_location, name="location"),
    path("collection/<str:collection_id>/", views.fetch_collection, name="collection"),
    path("highlight/<str:highlight_id>/", views.fetch_highlight, name="highlight"),
    path("resource/<str:resource_id>/", views.fetch_resource, name="resource"),
    path("hashtag/<str:hashtag_id>/", views.fetch_hashtag, name="hashtag"),
    path("track/<str:track_id>/", views.fetch_track, name="track"),
    path("note/<str:note_id>/", views.fetch_note, name="note"),
    path("note_user/<str:note_user_id>/", views.fetch_note_user, name="note_user"),
    path(
        "direct_message/<str:dm_id>/",
        views.fetch_direct_message,
        name="direct_message",
    ),
    path(
        "dm_user/<str:dm_user_id>/",
        views.fetch_direct_message_user,
        name="dm_user",
    ),
    path(
        "relationship_user/<str:rel_user_id>/",
        views.fetch_relationship_user,
        name="relationship_user",
    ),
    path(
        "direct_thread/<str:thread_id>/",
        views.fetch_direct_thread,
        name="direct_thread",
    ),
    path("dt_user/<str:dt_user_id>/", views.fetch_direct_thread_user, name="dt_user"),
    path(
        "relationship/<str:relationship_id>/",
        views.fetch_relationship,
        name="relationship",
    ),
    path("story/<str:story_id>/", views.fetch_story, name="story"),
    path(
        "story_user/<str:story_user_id>/",
        views.fetch_story_user,
        name="story_user",
    ),
    path(
        "story_hashtag/<str:story_hashtag_id>/",
        views.fetch_story_hashtag,
        name="story_hashtag",
    ),
    path("story_link/<str:story_link_id>/", views.fetch_story_link, name="story_link"),
    # Remove the problematic URL pattern
    # path("link/<str:link_id>/", views.fetch_link, name="link"),
    path(
        "story_highlight/<str:story_highlight_id>/",
        views.fetch_story_highlight,
        name="story_highlight",
    ),
    path(
        "story_mention/<str:story_mention_id>/",
        views.fetch_story_mention,
        name="story_mention",
    ),
    path("constants/<str:constants_id>/", views.fetch_constants, name="constants"),
    path(
        "story_location/<str:story_location_id>/",
        views.fetch_story_location,
        name="story_location",
    ),
    path(
        "story_hashtag/<str:story_hashtag_id>/",
        views.fetch_story_hashtag,
        name="story_hashtag",
    ),
    path(
        "story_sticker/<str:story_sticker_id>/",
        views.fetch_story_sticker,
        name="story_sticker",
    ),
    path(
        "dm_thread/<str:dm_thread_id>/",
        views.fetch_direct_message_thread,
        name="dm_thread",
    ),
    path("media/<str:media_id>/", views.fetch_media, name="media"),
    path(
        "user_media/<str:user_media_id>/",
        views.fetch_user_media,
        name="user_media",
    ),
    path(
        "highlight_media/<str:highlight_media_id>/",
        views.fetch_highlight_media,
        name="highlight_media",
    ),
    path(
        "media_resource/<str:media_resource_id>/",
        views.fetch_media_resource,
        name="media_resource",
    ),
    path("comment/<str:comment_id>/", views.fetch_comment, name="comment"),
    path(
        "story_comment/<str:story_comment_id>/",
        views.fetch_story_comment,
        name="story_comment",
    ),
    path("usertag/<str:usertag_id>/", views.fetch_usertag, name="usertag"),
    path(
        "media_usertag/<str:media_usertag_id>/",
        views.fetch_media_usertag,
        name="media_usertag",
    ),
    path(
        "media_sponsor/<str:media_sponsor_id>/",
        views.fetch_media_sponsor,
        name="media_sponsor",
    ),
    path(
        "media_comment/<str:media_comment_id>/",
        views.fetch_media_comment,
        name="media_comment",
    ),
    path(
        "media_location/<str:media_location_id>/",
        views.fetch_media_location,
        name="media_location",
    ),
    path(
        "media_story/<str:media_story_id>/",
        views.fetch_media_story,
        name="media_story",
    ),
    path(
        "media_hashtag/<str:media_hashtag_id>/",
        views.fetch_media_hashtag,
        name="media_hashtag",
    ),
    path(
        "story_usertag/<str:story_usertag_id>/",
        views.fetch_story_usertag,
        name="story_usertag",
    ),
    path(
        "story_location/<str:story_location_id>/",
        views.fetch_story_location,
        name="story_location",
    ),
    path(
        "story_sticker/<str:story_sticker_id>/",
        views.fetch_story_sticker,
        name="story_sticker",
    ),
    path(
        "comment_reply/<str:comment_reply_id>/",
        views.fetch_comment_reply,
        name="comment_reply",
    ),
    path(
        "comment_mention/<str:comment_mention_id>/",
        views.fetch_comment_mention,
        name="comment_mention",
    ),
]

from instagrapi import Client


class InstagramService:
    def __init__(self, username, password):
        self.client = Client()
        self.is_authenticated = False
        try:
            self.client.login(username, password)
            self.is_authenticated = True
        except Exception as e:
            print(f"Failed to authenticate Instagram user {username}: {str(e)}")

    def fetch_profile_data(self):
        if not self.is_authenticated:
            return None
        user_info = self.client.account_info()
        return {
            "username": user_info.username,
            "full_name": user_info.full_name,
            "profile_pic_url": user_info.profile_pic_url,
            "follower_count": user_info.follower_count,
            "following_count": user_info.following_count,
            "biography": user_info.biography,
            "media_count": user_info.media_count,
        }

    def fetch_recent_media(self, count=10):
        if not self.is_authenticated:
            return []
        media_items = self.client.user_medias(self.client.user_id, count)
        return [
            {
                "id": media.pk,
                "media_type": media.media_type,
                "thumbnail_url": media.thumbnail_url,
                "media_url": media.url,
                "caption": media.caption_text,
                "like_count": media.like_count,
                "comment_count": media.comment_count,
            }
            for media in media_items
        ]

    # Fetch insights for the authenticated user's account
    def fetch_account_insights(self):
        if self.is_authenticated:
            return self.client.insights_account()
        return {}

    # Fetch insights for a specific media by media ID
    def fetch_media_insights(self, media_id):
        if self.is_authenticated:
            return self.client.insights_media(media_id)
        return {}

    # Fetch feed insights with options for post type and time frame
    def fetch_feed_insights(
        self,
        post_type="ALL",
        time_frame="ONE_WEEK",
        data_ordering="REACH_COUNT",
        count=0,
    ):
        if self.is_authenticated:
            return self.client.insights_media_feed_all(
                post_type, time_frame, data_ordering, count
            )
        return []

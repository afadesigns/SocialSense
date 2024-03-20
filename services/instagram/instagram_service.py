from instagrapi import Client


class InstagramService:
    def __init__(self, username, password):
        """
        Initialize the Instagram service with user credentials and authenticate.
        """
        self.client = Client()
        self.is_authenticated = False
        try:
            self.client.login(username, password)
            self.is_authenticated = True
        except Exception as e:
            print(f"Failed to authenticate Instagram user {username}: {str(e)}")

    def fetch_profile_data(self):
        """
        Fetches the profile data of the authenticated user.
        """
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
        """
        Fetches recent media posts by the authenticated user.

        Args:
        - count (int): Number of recent media posts to fetch.
        """
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


# Example usage
if __name__ == "__main__":
    username = "your_instagram_username"
    password = "your_instagram_password"
    service = InstagramService(username, password)
    if service.is_authenticated:
        print("Profile Data:", service.fetch_profile_data())
        print("Recent Media:", service.fetch_recent_media())

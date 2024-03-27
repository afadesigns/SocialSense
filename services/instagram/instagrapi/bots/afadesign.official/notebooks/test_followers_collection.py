from unittest.mock import patch, MagicMock

from followers_collection import save_followers_to_db_with_details_batch_async


class MockFollower:
    def __init__(self, username, full_name=None, pk=None):
        self.username = username
        self.full_name = full_name
        self.pk = pk


class MockFollowerInfo:
    def __init__(
        self,
        biography=None,
        follower_count=None,
        following_count=None,
        media_count=None,
        engagement_rate=None,
        average_likes_per_post=None,
        average_comments_per_post=None,
        engagement_ratio=None,
        recent_activity=None,
        follower_growth=None,
    ):
        self.biography = biography
        self.follower_count = follower_count
        self.following_count = following_count
        self.media_count = media_count
        self.engagement_rate = engagement_rate
        self.average_likes_per_post = average_likes_per_post
        self.average_comments_per_post = average_comments_per_post
        self.engagement_ratio = engagement_ratio
        self.recent_activity = recent_activity
        self.follower_growth = follower_growth


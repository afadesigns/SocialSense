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


class TestFollowersCollection:

    @patch("followers_collection.create_engine")
    async def test_save_followers_to_db_success(self, mock_create_engine):
        # Mocking the SQLAlchemy engine and session
        mock_engine = MagicMock()
        mock_session = MagicMock()
        mock_create_engine.return_value = mock_engine
        mock_engine.return_value = mock_session

        # Create mock followers with details
        mock_followers_with_details = [
            (
                MockFollower(username="user1", full_name="User One Full Name", pk=123),
                MockFollowerInfo(
                    biography="User One Bio",
                    follower_count=100,
                    following_count=200,
                    media_count=50,
                    engagement_rate=0.05,
                    average_likes_per_post=20,
                    average_comments_per_post=10,
                    engagement_ratio=0.15,
                    recent_activity="2022-01-01",
                    follower_growth=0.1,
                ),
            ),
            (
                MockFollower(username="user2", full_name="User Two Full Name", pk=456),
                MockFollowerInfo(
                    biography="User Two Bio",
                    follower_count=150,
                    following_count=250,
                    media_count=70,
                    engagement_rate=0.07,
                    average_likes_per_post=25,
                    average_comments_per_post=15,
                    engagement_ratio=0.22,
                    recent_activity="2022-01-02",
                    follower_growth=0.2,
                ),
            ),
        ]

        # Call the function under test and pass the mock session
        await save_followers_to_db_with_details_batch_async(
            mock_followers_with_details, "test_account"
        )

        # Assertions reflecting operations on mock_session
        assert (
            mock_session.bulk_save_objects.call_count == 1
        )  # Expecting one call to bulk_save_objects
        mock_session.commit.assert_called_once()
        mock_session.close.assert_called_once()

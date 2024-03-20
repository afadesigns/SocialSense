# followers_collection.py

import json
import logging
import os
import sys
import time
from datetime import datetime

import redis
from cachetools import TTLCache
from dotenv import load_dotenv

from instagrapi import Client
from instagrapi.exceptions import (
    ChallengeRequired,
    ClientError,
    PleaseWaitFewMinutes,
    TwoFactorRequired,
    BadPassword,
    LoginRequired,
)

# Load environment variables from .env file
load_dotenv()

# Verify presence of required environment variables
INSTA_USERNAME = os.getenv("INSTA_USERNAME")
INSTA_PASSWORD = os.getenv("INSTA_PASSWORD")
if not INSTA_USERNAME or not INSTA_PASSWORD:
    print("Error: INSTA_USERNAME or INSTA_PASSWORD not set in environment variables.")
    sys.exit(1)


def setup_logging():
    """Configure logging."""
    logging.basicConfig(level=os.getenv("LOG_LEVEL", "INFO").upper())
    logger_inst = logging.getLogger(__name__)  # Rename to logger_inst
    handler = logging.StreamHandler(sys.stdout)
    formatter = logging.Formatter("%(asctime)s - %(levelname)s - %(message)s")
    handler.setFormatter(formatter)
    logger_inst.addHandler(handler)
    return logger_inst


# Initialize cache for storing follower details temporarily
follower_info_cache = TTLCache(maxsize=1000, ttl=3600)

logger = setup_logging()


def validate_follower_data(follower_info, username):
    """Ensure follower data has necessary attributes and valid content."""
    if not follower_info:
        logger.error({"error": "Follower data is None.", "username": username})
        raise ValueError(f"Follower data for {username} is None.")
    required_attrs = ["username", "full_name", "pk"]
    missing_attrs = [attr for attr in required_attrs if not follower_info.get(attr)]
    if missing_attrs:
        logger.error(
            {
                "error": "Missing required attributes.",
                "username": username,
                "missing_attrs": missing_attrs,
            }
        )
        raise ValueError(f"Missing required attributes for {username}: {missing_attrs}")


def calculate_engagement_metrics(api_client, user_id):
    """Calculate engagement metrics based on the user's recent posts."""
    try:
        posts = api_client.user_feed(user_id, amount=10)
        total_likes = sum(post.like_count for post in posts)
        total_comments = sum(post.comment_count for post in posts)
        post_count = len(posts)
        avg_likes = total_likes / post_count if post_count else 0
        avg_comments = total_comments / post_count if post_count else 0
        engagement_ratio = (
            (total_likes + total_comments) / post_count if post_count else 0
        )
        return avg_likes, avg_comments, engagement_ratio
    except (ChallengeRequired, PleaseWaitFewMinutes, ClientError) as ex:
        logger.error(
            {"error": "Error calculating engagement metrics.", "exception": str(ex)}
        )
        return 0, 0, 0


class FetchError(Exception):
    """Custom exception class for fetch errors."""

    def __init__(self, message):
        self.message = message
        super().__init__(message)


def retry_on_error(retries=3, delay=1, backoff=2):
    def decorator(func):
        def wrapper(*args, **kwargs):
            current_delay = delay  # Initialize delay here
            for _ in range(retries):
                try:
                    return func(*args, **kwargs)
                except (ChallengeRequired, PleaseWaitFewMinutes, ClientError) as ex:
                    logger.warning(
                        {
                            "warning": "Retrying after recoverable error.",
                            "exception": str(ex),
                        }
                    )
                    time.sleep(current_delay)
                    current_delay *= backoff
            raise FetchError("Max retries exceeded. Error not recoverable.")

        return wrapper

    return decorator


@retry_on_error(retries=3, delay=1, backoff=2)
def fetch_follower_details(api_client, username):
    """Fetch detailed information for a specific follower."""
    cached_data = follower_info_cache.get(username)
    if cached_data:
        logger.debug(
            {"message": "Using cached data for follower.", "username": username}
        )
        return cached_data
    try:
        logger.debug(
            {"message": "Fetching details for follower.", "username": username}
        )
        follower_info = api_client.user_info_by_username(username)
        validate_follower_data(follower_info, username)
        metrics = calculate_engagement_metrics(api_client, follower_info.pk)
        follower_data = {
            "username": follower_info.username,
            "full_name": follower_info.full_name,
            "user_id": follower_info.pk,
            "average_likes_per_post": metrics[0],
            "average_comments_per_post": metrics[1],
            "engagement_ratio": metrics[2],
            "recent_activity": datetime.now(),
        }
        follower_info_cache[username] = follower_data
        save_follower_data(follower_data)  # Save to PostgreSQL with caching
        return follower_data
    except ClientError as ex:
        logger.error(
            {
                "error": "Error fetching details for follower.",
                "exception": str(ex),
                "username": username,
            }
        )
        return None
    except ValueError as ve:
        logger.error(
            {
                "error": "Error validating follower data.",
                "exception": str(ve),
                "username": username,
            }
        )
        return None
    except Exception as e:
        logger.error(
            {
                "error": "Unexpected error during fetch_follower_details.",
                "exception": str(e),
                "username": username,
            }
        )
        return None


# Redis Configuration
REDIS_HOST = os.getenv("REDIS_HOST", "localhost")
REDIS_PORT = os.getenv("REDIS_PORT", "6379")
REDIS_DB = os.getenv("REDIS_DB", "0")
redis_client = redis.StrictRedis(host=REDIS_HOST, port=REDIS_PORT, db=REDIS_DB)


def save_follower_data(follower_data):
    """Save follower data to PostgreSQL with caching."""
    try:
        redis_client.setex(follower_data["username"], 3600, json.dumps(follower_data))
        logger.debug(
            {
                "message": "Follower data cached in Redis.",
                "username": follower_data["username"],
            }
        )
    except Exception as e:
        logger.error(
            {
                "error": "Error caching follower data in Redis.",
                "exception": str(e),
                "username": follower_data["username"],
            }
        )


def login_user(username, password):
    """
    Log in the user using the provided credentials.
    """
    api_client = Client()
    try:
        api_client.login(username, password)
        logger.info({"message": "Login successful.", "username": username})
        return api_client
    except (TwoFactorRequired, BadPassword, LoginRequired) as ex:
        if isinstance(ex, TwoFactorRequired):
            logger.info(
                {"message": "Two-factor authentication required.", "username": username}
            )
            # Prompt for 2FA code and retry login
            verification_code = input("Enter your 2FA code: ")
            return handle_2fa_login_exception(
                ex, api_client, username, verification_code
            )
        else:
            return handle_login_exception(ex, api_client, username)
    except Exception as e:
        logger.error(
            {
                "error": "Unexpected error during login.",
                "exception": str(e),
                "username": username,
            }
        )
        return None


def handle_2fa_login_exception(ex, api_client, username, verification_code):
    """
    Handle TwoFactorRequired exception during login.
    """
    if not verification_code.strip():
        logger.error({"error": "Verification code not provided.", "username": username})
        return None
    two_factor_identifier = api_client.last_json.get("two_factor_info", {}).get(
        "two_factor_identifier"
    )
    data = {
        "verification_code": verification_code,
        "phone_id": api_client.phone_id,
        "_csrftoken": api_client.token,
        "two_factor_identifier": two_factor_identifier,
        "username": username,
        "trust_this_device": "0",
        "guid": api_client.uuid,
        "device_id": api_client.android_device_id,
        "waterfall_id": str(uuid4()),
        "verification_method": "3",
    }
    try:
        logged = api_client.private_request(
            "accounts/two_factor_login/", data, login=True
        )
        return api_client.update_client_settings(api_client.get_settings())
    except Exception as e:
        logger.error(
            {
                "error": "Error during 2FA login.",
                "exception": str(e),
                "username": username,
            }
        )
        return None


if __name__ == "__main__":
    client = login_user(INSTA_USERNAME, INSTA_PASSWORD)
    if client:
        logger.info(
            {"message": "Proceeding with main logic.", "username": INSTA_USERNAME}
        )
        followers = client.user_followers(INSTA_USERNAME)  # Updated line
        for follower in followers:
            logger.info({"message": "Follower", "follower": follower})
    else:
        logger.error({"error": "Login failed.", "username": INSTA_USERNAME})

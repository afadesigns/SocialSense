#  Copyright (c) 2024. Lorem ipsum dolor sit amet, consectetur adipiscing elit.
#  Morbi non lorem porttitor neque feugiat blandit. Ut vitae ipsum eget quam lacinia accumsan.
#  Etiam sed turpis ac ipsum condimentum fringilla. Maecenas magna.
#  Proin dapibus sapien vel ante. Aliquam erat volutpat. Pellentesque sagittis ligula eget metus.
#  Vestibulum commodo. Ut rhoncus gravida arcu.

# C:/Users/Andreas/Projects/SocialSense/dashboard/home/instagram_utils.py

import logging
import sys
from typing import Dict, List, Optional

from instagrapi import Client
from instagrapi.exceptions import BadPassword, LoginRequired, TwoFactorRequired

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def login_instagram(username: str, password: str) -> Client:
    """
    Log in to Instagram and return the client object.
    """
    client = Client()
    try:
        client.login(username, password)
    except (BadPassword, LoginRequired) as ex:
        logger.error(
            {
                "error": "Bad password or login required.",
                "exception": str(ex),
                "username": username,
            }
        )
        sys.exit(1)
    except TwoFactorRequired as ex:
        logger.info(
            {"message": "Two-factor authentication required.", "username": username}
        )
        # Prompt for 2FA code and retry login
        verification_code = input("Enter your 2FA code: ")
        # Retry login with 2FA code
        try:
            client.login(username, password, verification_code=verification_code)
            logger.info(
                {"message": "Login successful after 2FA.", "username": username}
            )
        except Exception as e:
            logger.error(
                {
                    "error": "Failed to log in after 2FA.",
                    "exception": str(e),
                    "username": username,
                }
            )
            sys.exit(1)
    except Exception as e:
        logger.error(
            {
                "error": "Unexpected error during login.",
                "exception": str(e),
                "username": username,
            }
        )
        sys.exit(1)

    return client

def login_user(username: str, password: str) -> Optional[Client]:
    """
    Log in the user using the provided credentials.
    """
    api_client = Client()
    try:
        api_client.login(username, password)
        logger.info({"message": "Login successful.", "username": username})
        return api_client
    except (TwoFactorRequired, BadPassword, LoginRequired) as ex:
        logger.error(
            {
                "error": "Bad password or login required.",
                "exception": str(ex),
                "username": username,
            }
        )
        return None
    except Exception as e:
        logger.error(
            {
                "error": "Unexpected error during login.",
                "exception": str(e),
                "username": username,
            }
        )
        return None

def fetch_profile_data(client: Client) -> Dict:
    # Fetch Instagram user profile data
    profile_data = client.account_info()
    return profile_data

def fetch_recent_media(client: Client) -> List[Dict]:
    """
    Fetch recent media for the authenticated user.
    """
    try:
        user_id = client.user_id
        recent_media_items = client.user_medias_v1(user_id, amount=5)
        media_info_list = []

        for media in recent_media_items:
            media_details = client.media_info(media.pk)
            url = None

            # Determine media URL based on media type
            if media_details.media_type == 1:  # Photo
                url = media_details.thumbnail_url
            elif media_details.media_type in [2, 3, 5]:  # Video, IGTV, Reel
                url = media_details.video_url
            elif media_details.media_type == 8:  # Album
                if media_details.resources:
                    first_resource = media_details.resources[0]
                    url = (
                        first_resource.video_url
                        if first_resource.media_type == 2
                        else first_resource.thumbnail_url
                    )

            # Safely access the caption attribute
            caption = None
            if getattr(media_details, "caption", None):
                caption = (
                    media_details.caption.text
                    if getattr(media_details.caption, "text", None)
                    else None
                )

            media_info_list.append({"id": media.pk, "url": url, "caption": caption})

        return media_info_list
    except Exception as e:
        logger.error(
            {
                "error": "Failed to fetch recent media.",
                "exception": str(e),
            }
        )
        return []

def fetch_direct_messages(client: Client) -> Dict:
    """
    Fetch direct message conversations

    Parameters
    ----------
    client: Client
        An instance of the instagrapi Client

    Returns
    -------
    dict
        A dictionary containing direct message conversations
    """
    try:
        direct_messages = client.direct_spam_inbox()
        return direct_messages
    except Exception as e:
        logger.error(
            {
                "error": "Failed to fetch direct messages.",
                "exception": str(e),
            }
        )


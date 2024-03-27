# C:\Users\Andreas\Projects\SocialSense\dashboard\home\services.py

import json
import logging
import os

import backoff
from django.conf import settings

from instagrapi import Client
from instagrapi.exceptions import (
    ChallengeRequired,
    RecaptchaChallengeForm,
    ReloginAttemptExceeded,
    SelectContactPointRecoveryForm,
    TwoFactorRequired,
)

# Define paths for saving and loading session files
SESSION_FILE_PATH = os.path.join(settings.BASE_DIR, "session.json")

# Define constant for "Bad Password"
BAD_PASSWORD_MESSAGE = "Bad Password"

logger = logging.getLogger(__name__)


def save_session_to_file(client):
    """
    Save the client's session to a file.
    """
    with open(SESSION_FILE_PATH, "w") as file:
        json.dump(client.settings, file)


def load_session_from_file():
    """
    Load the client's session from a file and return a client instance.
    """
    client = Client()
    try:
        with open(SESSION_FILE_PATH, "r") as file:
            session_settings = json.load(file)
            client.load_settings(session_settings)
    except FileNotFoundError:
        # If the session file doesn't exist, proceed with a fresh login
        client.login(
            username=settings.INSTAGRAM_USERNAME, password=settings.INSTAGRAM_PASSWORD
        )
        save_session_to_file(client)  # Save the new session for future use
    return client


# Centralized proxy management
def manage_proxy(client):
    client.set_proxy(client.next_proxy().href)
    client.settings = client.rebuild_client_settings()
    return client.update_client_settings(client.get_settings())


def handle_bad_password(client):
    client.logger.exception(BAD_PASSWORD_MESSAGE)
    if client.relogin_attempt > 0:
        client.freeze(BAD_PASSWORD_MESSAGE, days=7)
        raise ReloginAttemptExceeded(BAD_PASSWORD_MESSAGE)
    return manage_proxy(client)


def handle_login_required(client):
    client.logger.exception("Login Required")
    client.relogin()
    return client.update_client_settings(client.get_settings())


def handle_challenge_required(client):
    api_path = client.last_json.get("challenge", {}).get("api_path")
    if api_path == "/challenge/":
        return manage_proxy(client)
    else:
        try:
            client.challenge_resolve(client.last_json)
        except ChallengeRequired:
            client.freeze("Manual Challenge Required", days=2)
            raise
        except (
            SelectContactPointRecoveryForm,
            RecaptchaChallengeForm,
        ) as e:
            client.freeze(str(e), days=4)
            raise
        client.update_client_settings(client.get_settings())
    return True


def handle_feedback_required(client):
    message = client.last_json["feedback_message"]
    if "This action was blocked. Please try again later" in message:
        client.freeze(message, hours=12)
    elif "We restrict certain activity to protect our community" in message:
        client.freeze(message, hours=12)
    elif "Your account has been temporarily blocked" in message:
        client.freeze(message)


def handle_please_wait_few_minutes(client):
    client.freeze("Please Wait Few Minutes", hours=1)


@backoff.on_exception(
    backoff.expo, (Client.ClientConnectionError, Client.Throttled), max_time=60
)
def get_instagrapi_client():
    cl = Client()
    try:
        cl.login(
            username=settings.INSTAGRAM_USERNAME,
            password=settings.INSTAGRAM_PASSWORD,
        )
        logger.info("Instagrapi client logged in successfully.")
        save_session_to_file(cl)  # Save the session after successful login
    except TwoFactorRequired as e:
        # Prompt for 2FA code
        verification_code = input(
            "Enter the 2FA verification code sent to your device: "
        )
        # Extract two_factor_identifier from the exception details
        two_factor_info = e.args[0]  # Assuming the first arg contains the needed info
        two_factor_identifier = two_factor_info.get("two_factor_identifier")

        # Complete 2FA login
        try:
            cl.two_factor_login(
                verification_code=verification_code,
                two_factor_identifier=two_factor_identifier,
                username=settings.INSTAGRAM_USERNAME,
                password=settings.INSTAGRAM_PASSWORD,
            )
            logger.info("Instagrapi client logged in successfully with 2FA.")
            save_session_to_file(cl)  # Save the session after successful login
        except Exception as e:
            logger.error(f"Failed to log in with 2FA: {e}")
            return None
    except Exception as e:
        logger.error(f"An unexpected error occurred while logging in: {e}")
        return None
    return cl


@backoff.on_exception(
    backoff.expo, (Client.ClientConnectionError, Client.Throttled), max_time=60
)
def use_instagrapi_client():
    instagrapi_client = get_instagrapi_client()
    if instagrapi_client:
        try:
            user_info = instagrapi_client.user_info_by_username(
                username="example_username"
            )
            return user_info
        except (Client.BadRequest, Client.Forbidden, Client.TemporaryBan) as e:
            logger.error(f"Instagram API error: {e}")
        except Client.Error as e:
            logger.error(f"Instagram client error: {e}")
    return None

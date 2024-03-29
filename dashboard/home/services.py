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


def manage_proxy(client):
    """
    Centralized proxy management.
    """
    client.set_proxy(client.next_proxy().href)
    client.settings = client.rebuild_client_settings()
    return client.update_client_settings(client.get_settings())


def handle_exception(exception):
    """
    Handle various exceptions during Instagram API operations.
    """
    if isinstance(exception, ChallengeRequired):
        # Handle challenge required
        api_path = exception.api_path
        if api_path == "/challenge/":
            return manage_proxy(exception.client)
        else:
            try:
                exception.client.challenge_resolve(exception.last_json)
            except ChallengeRequired:
                exception.client.freeze("Manual Challenge Required", days=2)
                raise
            except (
                SelectContactPointRecoveryForm,
                RecaptchaChallengeForm,
            ) as e:
                exception.client.freeze(str(e), days=4)
                raise
            exception.client.update_client_settings(exception.client.get_settings())
        return True
    elif isinstance(exception, ReloginAttemptExceeded):
        # Handle relogin attempt exceeded
        exception.client.freeze(BAD_PASSWORD_MESSAGE, days=7)
        raise exception
    elif isinstance(exception, TwoFactorRequired):
        # Handle two-factor authentication required
        try:
            handle_two_factor_authentication(exception)
        except Exception as e:
            logger.error(f"Failed to log in with 2FA: {e}")
            return None
    elif isinstance(exception, Client.ClientConnectionError):
        # Handle client connection error
        raise exception
    elif isinstance(exception, Client.Throttled):
        # Handle throttled
        raise exception
    else:
        logger.error(f"An unexpected error occurred: {exception}")
        return None


@backoff.on_exception(
    backoff.expo, (Client.ClientConnectionError, Client.Throttled), max_time=60
)
def get_instagrapi_client():
    """
    Get an instance of Instagrapi client.
    """
    cl = Client()
    try:
        cl.login(
            username=settings.INSTAGRAM_USERNAME,
            password=settings.INSTAGRAM_PASSWORD,
        )
        logger.info("Instagrapi client logged in successfully.")
        save_session_to_file(cl)  # Save the session after successful login
    except TwoFactorRequired as e:
        # Handle two-factor authentication required
        handle_two_factor_authentication(e)
    except Exception as e:
        handle_exception(e)
    return cl


def handle_two_factor_authentication(exception):
    """
    Handle two-factor authentication required.
    """
    verification_code = input("Enter the 2FA verification code sent to your device: ")
    # Extract two_factor_identifier from the exception details
    two_factor_info = exception.args[
        0
    ]  # Assuming the first arg contains the needed info
    two_factor_identifier = two_factor_info.get("two_factor_identifier")
    # Complete 2FA login
    exception.client.two_factor_login(
        verification_code=verification_code,
        two_factor_identifier=two_factor_identifier,
        username=settings.INSTAGRAM_USERNAME,
        password=settings.INSTAGRAM_PASSWORD,
    )
    logger.info("Instagrapi client logged in successfully with 2FA.")
    save_session_to_file(exception.client)  # Save the session after successful login


@backoff.on_exception(
    backoff.expo, (Client.ClientConnectionError, Client.Throttled), max_time=60
)
def use_instagrapi_client():
    """
    Use Instagrapi client for Instagram API operations.
    """
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

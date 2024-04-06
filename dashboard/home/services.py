import json
import logging
import os
import time
from typing import Any

import backoff
from django.conf import settings

import instagrapi
from instagrapi.exceptions import (
    ChallengeRequired,
    ClientConnectionError,
    RecaptchaChallengeForm,
    ReloginAttemptExceeded,
    SelectContactPointRecoveryForm,
    TwoFactorRequired,
    TemporaryBan,
)

SESSION_FILE_PATH = os.path.join(settings.BASE_DIR, "session.json")
BAD_PASSWORD_MESSAGE = "Bad Password"
logger = logging.getLogger(__name__)


def save_session_to_file(client: instagrapi.Client) -> None:
    with open(SESSION_FILE_PATH, "w") as file:
        json.dump(client.settings, file)


def load_session_from_file() -> instagrapi.Client:
    client = instagrapi.Client()
    try:
        with open(SESSION_FILE_PATH, "r") as file:
            session_settings = json.load(file)
            client.load_settings(session_settings)
    except FileNotFoundError:
        pass
    return client


def manage_proxy(client: instagrapi.Client) -> instagrapi.Client:
    """
    Centralized proxy management.
    """
    client.set_proxy(client.next_proxy().href)
    client.settings = client.rebuild_client_settings()
    return client.update_client_settings(client.get_settings())


def handle_exception(client: instagrapi.Client, e: Exception) -> bool:
    """
    Handle various exceptions during Instagram API operations.
    """
    if isinstance(e, ChallengeRequired):
        # Handle challenge required
        api_path = e.api_path
        if api_path == "/challenge/":
            return manage_proxy(client)
        else:
            try:
                client.challenge_resolve(e.last_json)
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
    elif isinstance(e, ReloginAttemptExceeded):
        # Handle relogin attempt exceeded
        client.freeze(BAD_PASSWORD_MESSAGE, days=7)
        raise e
    elif isinstance(e, TwoFactorRequired):
        # Handle two-factor authentication required
        handle_two_factor_authentication(client, e)
    elif isinstance(e, ClientConnectionError):
        # Handle client connection error
        client.freeze("Client Connection Error", hours=1)
    elif isinstance(e, TemporaryBan):
        # Handle temporary ban
        client.freeze("Temporary Ban", hours=1)
    else:
        logger.error(f"An unexpected error occurred: {e}")
        return None
    return False


def handle_two_factor_authentication(client: instagrapi.Client, e: TwoFactorRequired) -> None:
    verification_code = input("Enter the 2FA verification code: ")
    two_factor_identifier = e.args[0].get("two_factor_identifier")
    try:
        client.two_factor_login(
            verification_code=verification_code,
            two_factor_identifier=two_factor_identifier,
            username=settings.INSTAGRAM_USERNAME,
            password=settings.INSTAGRAM_PASSWORD,
        )
        save_session_to_file(client)
        logger.info("Instagrapi client logged in successfully with 2FA.")
    except Exception as e:
        logger.error(f"Failed to log in with 2FA: {e}")
        client.freeze("2FA Login Failed", hours=1)


def is_session_expired() -> bool:
    return time.time() - os.path.getmtime(SESSION_FILE_PATH) > 3600


@backoff.on_exception(
    backoff.expo, (ClientConnectionError, TemporaryBan), max_time=60
)
def get_instagrapi_client() -> instagrapi.Client:
    """
    Get an instance of Instagrapi client.
    """
    cl = instagrapi.Client()
    try:
        cl.login(
            username=settings.INSTAGRAM_USERNAME,
            password=settings.INSTAGRAM_PASSWORD,
        )
        save_session_to_file(cl)
    except TwoFactorRequired as e:
        handle_two_factor_authentication(cl, e)
    except Exception as e:
        handle_exception(cl, e)
    return cl if not is_session_expired() else load_session_from_file()


def use_instagrapi_client(client: instagrapi.Client) -> Any:
    try:
        user_info = client.user_info_by_username(username="example_username")
        return user_info
    except (instagrapi.Client.BadRequest, instagrapi.Client.Forbidden, instagrapi.Client.TemporaryBan) as e:
        handle_exception(client, e)
    except instagrapi.Client.Error as e:
        logger.error(f"Instagram client error: {e}")
    return None

# C:\Users\Andreas\Projects\SocialSense\dashboard\home\services.py

import json
import logging
import os
import time
from typing import Any

import backoff
from django.conf import settings

from instagrapi import Client
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


def save_session_to_file(client):
    with open(SESSION_FILE_PATH, "w") as file:
        json.dump(client.settings, file)


def load_session_from_file() -> Client:
    client = Client()
    try:
        with open(SESSION_FILE_PATH, "r") as file:
            session_settings = json.load(file)
            client.load_settings(session_settings)
    except FileNotFoundError:
        pass
    return client


def manage_proxy(client):
    client.set_proxy(client.next_proxy().href)
    client.settings = client.rebuild_client_settings()
    return client.update_client_settings(client.get_settings())


def handle_exception(client, e: Exception):
    if isinstance(e, ReloginAttemptExceeded):
        client.freeze(BAD_PASSWORD_MESSAGE, days=7)
        raise e
    elif isinstance(e, TwoFactorRequired):
        handle_two_factor_required(client, e)
    elif isinstance(e, ChallengeRequired):
        handle_challenge_required(client)
    elif isinstance(e, ClientConnectionError) or isinstance(e, TemporaryBan):
        client.freeze("Temporary Ban", hours=1)
    else:
        logger.exception(e)


def handle_two_factor_required(client, e: TwoFactorRequired):
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
    except Exception as e:
        logger.error(f"Failed to log in with 2FA: {e}")
        client.freeze("2FA Login Failed", hours=1)


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
        except (SelectContactPointRecoveryForm, RecaptchaChallengeForm) as e:
            client.freeze(str(e), days=4)
            raise
        client.update_client_settings(client.get_settings())


def is_session_expired(client) -> bool:
    return time.time() - os.path.getmtime(SESSION_FILE_PATH) > 3600


@backoff.on_exception(
    backoff.expo, (ClientConnectionError, TemporaryBan), max_time=60
)
def get_instagrapi_client() -> Client:
    cl = Client()
    try:
        cl.login(
            username=settings.INSTAGRAM_USERNAME,
            password=settings.INSTAGRAM_PASSWORD,
        )
        save_session_to_file(cl)
    except TwoFactorRequired as e:
        handle_two_factor_required(cl, e)
    except Exception as e:
        handle_exception(cl, e)
    return cl if not is_session_expired(cl) else load_session_from_file()


@backoff.on_exception(
    backoff.expo, (ClientConnectionError, TemporaryBan), max_time=60
)
def use_instagrapi_client(client: Client) -> Any:
    try:
        user_info = client.user_info_by_username(username="example_username")
        return user_info
    except (Client.BadRequest, Client.Forbidden, Client.TemporaryBan) as e:
        handle_exception(client, e)
    except Client.Error as e:
        logger.error(f"Instagram client error: {e}")
    return None

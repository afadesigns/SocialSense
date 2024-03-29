import json
import logging
import random
import time
from typing import Any, Dict, Optional

import requests
from requests.adapters import HTTPAdapter
from requests.packages.urllib3.util.retry import Retry
from typing_extensions import Literal

import instagrapi
from instagrapi.exceptions import (
    BadPassword,
    ChallengeRequired,
    ClientBadRequestError,
    ClientConnectionError,
    ClientError,
    ClientForbiddenError,
    ClientJSONDecodeError,
    ClientNotFoundError,
    ClientRequestTimeout,
    ClientThrottledError,
    FeedbackRequired,
    InvalidMediaId,
    InvalidTargetUser,
    LoginRequired,
    MediaUnavailable,
    PleaseWaitFewMinutes,
    PrivateAccount,
    ProxyAddressIsBlocked,
    RateLimitError,
    SentryBlock,
    TwoFactorRequired,
    UnknownError,
    UserNotFound,
    VideoTooLongException,
)
from instagrapi.utils import dumps, generate_signature, random_delay


def manual_input_code(self: instagrapi.Client, username: str, choice: Optional[Literal["sms", "email"]] = None) -> str:
    """
    Manual security code helper

    Parameters
    ----------
    username: str
        User name of a Instagram account
    choice: optional
        Whether sms or email

    Returns
    -------
    str
        Code
    """
    code = None
    while True:
        code = input(f"Enter code (6 digits) for {username} ({choice}): ").strip()
        if code and code.isdigit():
            break
    return code  # is not int, because it can start from 0


def manual_change_password(self: instagrapi.Client, username: str) -> str:
    pwd = None
    while not pwd:
        pwd = input(f"Enter password for {username}: ").strip()
    return pwd


class PrivateRequestMixin:
    """
    Helpers for private request
    """

    private_requests_count = 0
    handle_exception: Optional[Callable[[instagrapi.Client, Exception], None]] = None
    challenge_code_handler = manual_input_code
    change_password_handler = manual_change_password
    private_request_logger = logging.getLogger("private_request")
    request_timeout = 1
    domain = config.API_DOMAIN
    last_response = None
    last_json: Dict[str, Any] = {}

    def __init__(
        self: instagrapi.Client,
        *args,
        email: Optional[str] = None,
        phone_number: Optional[str] = None,
        request_timeout: int = 1,
        **kwargs,
    ):
        # setup request session with retries
        session = requests.Session()
        try:
            retry_strategy = Retry(
                total=3,
                status_forcelist=[429, 500, 502, 503, 504],
                allowed_methods=["GET", "POST"],
                backoff_factor=2,
            )
        except TypeError:
            retry_strategy = Retry(
                total=3,
                status_forcelist=[429, 500, 502, 503, 504],
                method_whitelist=["GET", "POST"],
                backoff_factor=2,
            )
        adapter = HTTPAdapter(max_retries=retry_strategy)
        session.mount("https://", adapter)
        session.mount("http://", adapter)
        self.private = session
        self.private.verify = False  # fix SSLError/HTTPSConnectionPool
        self.email = email
        self.phone_number = phone_number
        self.request_timeout = request_timeout
        super().__init__(*args, **kwargs)

    def small_delay(self) -> None:
        """
        Small Delay

        Returns
        -------
        Void
        """
        time.sleep(random.uniform(0.75, 3.75))

    def very_small_delay(self) -> None:
        """
        Very small delay

        Returns
        -------
        Void
        """
        time.sleep(random.uniform(0.175, 0.875))

    @property
    def base_headers(self) -> Dict[str, str]:
        locale = self.locale.replace("-", "_")
        accept_language = ["en-US"]
        if locale:
            lang = locale.replace("_", "-")
            if lang not in

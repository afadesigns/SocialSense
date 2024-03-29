import json
import logging
import random
import time
from json.decoder import JSONDecodeError
from typing import Any, Dict, Optional

import requests
from requests.adapters import HTTPAdapter
from requests.packages.urllib3.util.retry import Retry
from typing import Callable, List, Union

import config
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

logger = logging.getLogger(__name__)

def manual_input_code(self: Any, username: str, choice: str = None) -> str:
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
        input_str = input(f"Enter code (6 digits) for {username} ({choice}): ").strip()
        if input_str.isdigit():
            code = int(input_str)
            break
        logger.error("Invalid code. Please enter a 6-digit code.")
    return code

def manual_change_password(self: Any, username: str) -> str:
    """
    Manual password change helper

    Parameters
    ----------
    username

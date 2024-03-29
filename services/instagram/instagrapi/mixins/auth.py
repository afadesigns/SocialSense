import base64
import hashlib
import hmac
import json
import random
import re
import time
import uuid
from pathlib import Path
from typing import Any, Callable, Dict, Literal, Optional, Union
from uuid import UUID, uuid4

import requests
from pydantic import ValidationError
from typing_extensions import Final, Literal as LiteralType

# from instagrapi.zones import CET
from typing import DefaultDict, Dict, List, Optional, Union
from typing_extensions import Final

import instagrapi
from instagrapi.config import (
    LOGIN_EXPERIMENTS,
    SUPPORTED_CAPABILITIES,
)
from instagrapi.exceptions import (
    BadCredentials,
    ClientThrottledError,
    PleaseWaitFewMinutes,
    PrivateError,
    ReloginAttemptExceeded,
    TwoFactorRequired,
)
from instagrapi.utils import dumps, gen_token, generate_jazoest

TIMELINE_FEED_REASONS: Final = (
    "cold_start_fetch",
    "warm_start_fetch",
    "pagination",
    "pull_to_refresh",
    "auto_refresh",
)
REELS_TRAY_REASONS: Final = ("cold_start", "pull_to_refresh")

try:
    from typing import Literal

    TIMELINE_FEED_REASON = Literal[TIMELINE_FEED_REASONS]
    REELS_TRAY_REASON = Literal[REELS_TRAY_REASONS]
except ImportError:
    # python <= 3.8
    TIMELINE_FEED_REASON = str
    REELS_TRAY_REASON = str


class PreLoginFlowMixin:
    """
    Helpers for pre login flow
    """

    def pre_login_flow(self) -> bool:
        """
        Emulation mobile app behavior before login

        Returns
        -------
        bool
            A boolean value
        """
        # self.set_contact_point_prefill("prefill")
        # self.get_prefill_candidates(True)
        # self.set_contact_point_prefill("prefill")
        self.sync_launcher(True)
        # self.sync_device_features(True)
        return True

    def get_prefill_candidates(self, login: bool = False) -> Dict[str, Any]:
        """
        Get prefill candidates value from Instagram

        Parameters
        ----------
        login: bool, optional
            Whether to login or not

        Returns
        -------
        Dict[str, Any]
            A dictionary of response from the call
        """
        data: Dict[str, Any] = {
            "android_device_id": self.android_device_id,
            "client_contact_points": [
                {
                    "type": "omnistring",
                    "value": self.username,
                    "source": "last_login_attempt",
                }
            ],
            "phone_id": self.phone_id,
            "usages": '["account_recovery_omnibox"]',
            "logged_in_user_ids": "[]",  # "[\"123456789\",\"987654321\"]",
            "device_id": self.uuid,
        }
        # if login is False:
        data["_csrftoken"] = self.token
        response = self.private_request(
            "accounts/get_prefill_candidates/", data, login=login
        )
        return response

    def sync_device_features(self, login: bool = False) -> Dict[str, Any]:
        """
        Sync device features to your Instagram account

        Parameters
        ----------
        login: bool, optional
            Whether to login or not

        Returns
        -------
        Dict[str, Any]
            A dictionary of response from the call
        """
        data: Dict[str, Any] = {
            "id": self.uuid,
            "server_config_retrieval": "1",
            # "experiments": config.LOGIN_EXPERIMENTS,
        }
        if login is False:
            data["_uuid"] = self.uuid
            data["_uid"] = self.user_id
            data["_csrftoken"] = self.token
        # headers={"X-DEVICE-ID": self.uuid}
        response = self.private_request("qe/sync/", data, login=login)
        return response

    def sync_launcher(self, login: bool = False) -> Dict[str, Any]:
        """
        Sync Launcher

        Parameters
        ----------
        login: bool, optional
            Whether to login or not

        Returns
        -------
        Dict[str, Any]
            A dictionary of response from the call
        """
        data: Dict[str, Any] = {
            "id": self.uuid,
            "server_config_retriev

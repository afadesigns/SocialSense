import hashlib
import json
import random
import time
from enum import Enum
from typing import Dict, Optional

import requests

from instagrapi.exceptions import (
    ChallengeError,
    ChallengeRedirection,
    ChallengeRequired,
    ChallengeSelfieCaptcha,
    ChallengeUnknownStep,
    LegacyForceSetNewPasswordForm,
    RecaptchaChallengeForm,
    SelectContactPointRecoveryForm,
    SubmitPhoneNumberForm,
)

WAIT_SECONDS = 5


class ChallengeChoice(Enum):
    SMS = 0
    EMAIL = 1


def extract_messages(challenge: Dict) -> list[str]:
    messages = []
    for item in challenge["extraData"].get("content", []):
        message = item.get("title", item.get("text"))
        if message:
            dot = "" if message.endswith(".") else "."
            messages.append(f"{message}{dot}")
    return messages


class ChallengeResolveMixin:
    """
    Helpers for resolving login challenge
    """

    def challenge_resolve(self, last_json: Dict) -> bool:
        """
        Start challenge resolve

        Returns
        -------
        bool
            A boolean value
        """
        challenge_url = last_json["challenge"]["api_path"]
        try:
            user_id, nonce_code = challenge_url.split("/")[2:4]
            challenge_context = last_json.get("challenge", {}).get("challenge_context")
            if not challenge_context:
                challenge_context = json.dumps(
                    {
                        "step_name": "",
                        "nonce_code": nonce_code,
                        "user_id": int(user_id),
                        "is_stateless": False,
                    }
                )
            params = {
                "guid": self.uuid,
                "device_id": self.android_device_id,
                "challenge_context": challenge_context,
            }
        except ValueError:
            params = {}

        try:
            self._send_private_request(challenge_url[1:], params=params)
        except ChallengeRequired:
            return self.challenge_resolve_contact_form(challenge_url)

        return self.challenge_resolve_simple(challenge_url)

    def challenge_resolve_contact_form(self, challenge_url: str) -> bool:
        # ... (rest of the method remains unchanged)

    def challenge_resolve_simple(self, challenge_url: str) -> bool:
        # ... (rest of the method remains unchanged)

    def handle_challenge_result(self, challenge: Dict) -> bool:
        # ... (rest of the method remains unchanged)

    def challenge_resolve_new_password_form(self, result):
        # ... (rest of the method remains unchanged)


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
    for item in challenge.get("extraData", {}).get("content", []):
        message = item.get("title", item.get("text"))
        if message:
            messages.append(f"{message}.")
    return messages

class ChallengeResolveMixin:
    """
    Helpers for resolving login challenge
    """

    def challenge_resolve(self, last_json: Dict) -> bool:
        challenge_url = last_json["challenge"]["api_path"]
        try:
            user_id, nonce_code = challenge_url.split("/")[2:4]
            challenge_context = last_json.get("challenge", {}).get("challenge_context")
            if not challenge_context:
              

import logging
from json.decoder import JSONDecodeError
from pathlib import Path
from typing import Dict, Any, Union, Optional

import requests

from instagrapi.exceptions import ClientError, ClientLoginRequired
from instagrapi.extractors import extract_account, extract_user_short
from instagrapi.types import Account, UserShort
from instagrapi.utils import dumps, gen_token

logger = logging.getLogger(__name__)

class AccountMixin:
    """
    Helper class to manage your account
    """

    def __init__(self, *args, **kwargs):
        # Initialize the logger
        logging.basicConfig(level=logging.DEBUG)

    def reset_password(self, username: str) -> Dict[str, Any]:
        """
        Reset your password

        Returns
        -------
        Dict[str, Any]
            Jsonified response from Instagram
        """
        headers = {
            "x-requested-with": "XMLHttpRequest",
            "x-csrftoken": gen_token(),
            "Connection": "Keep-Alive",
            "Accept": "*/*",
            "Accept-Encoding": "gzip,deflate",
            "Accept-Language": "en-US",
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/11.1.2 Safari/605.1.15",
        }
        data = {"email_or_username": username, "recaptcha_challenge_field": ""}
        try:
            response = requests.post(
                "https://www.instagram.com/accounts/account_recovery_send_ajax/",
                data=data,
                headers=headers,
                proxies=self.public.proxies,
                timeout=self.request_timeout,
            )
            response.raise_for_status()
            return response.json()
        except JSONDecodeError as e:
            if "/login/" in response.url:
                raise ClientLoginRequired(e, response=response)
            raise ClientError(e, response=response)

    def account_info(self) -> Account:
        """
        Fetch your account info

        Returns
        -------
        Account
            An object of Account class
        """
        result = self.private_request("accounts/current_user/?edit=true")
        return extract_account(result["user"])

    def change_password(
        self,
        old_password: str,
        new_password: str,
    ) -> bool:
        """
        Change password

        Parameters
        ----------
        new_password: str
            New password
        old_password: str
            Old password

        Returns
        -------
        bool
            A boolean value
        """
        try:
            enc_old_password = self.password_encrypt(old_password)
            enc_new_password = self.password_encrypt(new_password)
            data = {
                "enc_old_password": enc_old_password,
                "enc_new_password1": enc_new_password,
                "enc_new_password2": enc_new_password,
            }
            self.with_action_data(
                {
                    "_uid": self.user_id,
                    "_uuid": self.uuid,
                    "_csrftoken": self.token,
                }
            )
            result = self.private_request("accounts/change_password/", data=data)
            return result
        except Exception as e:
            logger.exception(e)
            return False

    def set_external_url(self, external_url) -> dict:
        """
        Set new biography
        """

        signed_body = f"signed_body=SIGNATURE.%7B%22updated_links%22%3A%22%5B%7B%5C%22url%5C%22%3A%5C%22{external_url}%5C%22%2C%5C%22title%5C%22%3A%5C%22%5C%22%2C%5C%22link_type%5C%22%3A%5C%22external%5C%22%7D%5D%22%2C%22_uid%22%3A%22{self.user_id}%22%2C%22_uuid%22%3A%22{self.uuid}%22%7D"
        return self.private_request(
            "accounts/update_bio_links/", data=signed_body, with_signature=False
        )

    def account_set_private(self) -> bool:
        """
        Sets your account private

        Returns
        -------
        Account
            An object of Account class
        """
        assert self.user_id, "Login required"
        user_id = str(self.user_id)
        data = self.with_action_data({"_uid": user_id, "_uuid": self.uuid})
        result = self.private_request("accounts/set_private/", data)
        return result["status"] == "ok"

    def account_set_public(self) -> bool:
        """
        Sets your account public

        Returns
        -------
        Account
            An object of Account class
        """
        assert self.user_id, "Login required"
        user_id = str(self.user_id)
        data = self.with_action_data({"_uid": user_id, "_uuid":

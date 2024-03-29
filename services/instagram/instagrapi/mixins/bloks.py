from instagrapi.utils import dumps
from typing import Dict, Union

class BloksMixin:
    """Mixin class for performing actions for bloks."""

    def __init__(self):
        self._bloks_versioning_id = ""

    @property
    def bloks_versioning_id(self) -> str:
        """The bloks versioning ID."""
        return self._bloks_versioning_id

    @bloks_versioning_id.setter
    def bloks_versioning_id(self, value: str) -> None:
        """Set the bloks versioning ID."""
        self._bloks_versioning_id = value

    def password_encrypt(self, password: str) -> str:
        """Encrypt the password."""
        # Implement the encryption logic here
        return password

    def bloks_action(
        self, action: str, data: Dict[str, Union[str, Dict[str, str]]]
    ) -> bool:
        """Perform an action for bloks.

        Parameters
        ----------
        action : str
            The action to perform.
        data : dict
            The data to send with the action.

        Returns
        -------
        bool
            True if the action was successful, False otherwise.
        """
        result = self.private_request(f"bloks/apps/{action}/", self.with_default_data(data))
        return result.get("status") == "ok"

    def bloks_change_password(
        self, password: str, challenge_context: Dict[str, str]
    ) -> bool:
        """Change the password for a challenge.

        Parameters
        ----------
        password : str
            The new password.
        challenge_context : dict
            The challenge context.

        Returns
        -------
        bool
            True if the password was changed successfully, False otherwise.
        """
        if not self.bloks_versioning_id:
            raise ValueError("Client.bloks

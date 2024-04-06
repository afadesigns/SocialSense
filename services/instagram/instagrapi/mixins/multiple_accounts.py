import typing

class MultipleAccountsMixin:
    """
    Helpers for multiple accounts.
    """

    def featured_accounts_v1(self, target_user_id: typing.Union[str, int]) -> typing.Dict:
        """
        Get featured accounts for the given target user ID.

        :param target_user_id: The ID of the target user. Can be either a string or an integer.
        :return: A dictionary containing the featured accounts.
        """
        target_user_id_str = str(target_user_id)
        if not isinstance(target_user_id_str, str):
            raise ValueError("target_user_id must be a string")

        if hasattr(self, "private_request"):
            return self.private_request(
                "multiple_accounts/get_featured_accounts/",
                params={"target_user_id": target_user_id_str},
            )
        else:
            raise NotImplementedError("private_request method not implemented")

    def get_account_family_v1(self) -> typing.Dict:
        """
        Get the account family.

        :return: A dictionary containing the account family.
        """
        if hasattr(self, "private_request"):
            return self.private_request("multiple_accounts/get_account_family/")
        else:
            raise NotImplementedError("private_

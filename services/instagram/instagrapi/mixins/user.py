from copy import deepcopy
from typing import Dict, List, Tuple, Union

from instagrapi.exceptions import (
    ClientError,
    ClientJSONDecodeError,
    ClientLoginRequired,
    ClientNotFoundError,
    UserNotFound,
)
from instagrapi.extractors import extract_user_gql, extract_user_short, extract_user_v1
from instagrapi.types import Relationship, RelationshipShort, User, UserShort
from instagrapi.utils import json_value

MAX_USER_COUNT = 200

class UserMixin:
    """
    Helpers to manage user
    """

    _users_cache: Dict[str, User] = {}  # user_pk -> User
    _userhorts_cache: Dict[str, UserShort] = {}  # user_pk -> UserShort
    _usernames_cache: Dict[str, str] = {}  # username -> user_pk
    _users_following: Dict[str, Dict[str, RelationshipShort]] = {}  # user_pk -> dict(user_pk -> "short user object")
    _users_followers: Dict[str, Dict[str, RelationshipShort]] = {}  # user_pk -> dict(user_pk -> "short user object")

    def user_id_from_username(self, username: str) -> str:
        """
        Get full media id

        Parameters
        ----------
        username: str
            Username for an Instagram account

        Returns
        -------
        str
            User PK

        Example
        -------
        'example' -> 1903424587
        """
        username = str(username).lower()
        return str(self.user_info_by_username(username).pk)

    def user_short_gql(self, user_id: str, use_cache: bool = True) -> UserShort:
        """
        Get full media id

        Parameters
        ----------
        user_id: str
            User ID
        use_cache: bool, optional
            Whether or not to use information from cache, default value is True

        Returns
        -------
        UserShort
            An object of UserShort type
        """
        if use_cache:
            cache = self._userhorts_cache.get(user_id)
            if cache:
                return cache
        variables = {
            "user_id": str(user_id),
            "include_reel": True,
        }
        data = self.public_graphql_request(
            variables, query_hash="ad99dd9d3646cc3c0dda65debcd266a7"
        )
        if not data["user"]:
            raise UserNotFound(user_id=user_id, **data)
        user = extract_user_short(data["user"]["reel"]["user"])
        self._userhorts_cache[user_id] = user
        return user

    def username_from_user_id_gql(self, user_id: str) -> str:
        """
        Get username from user id

        Parameters
        ----------
        user_id: str
            User ID

        Returns
        -------


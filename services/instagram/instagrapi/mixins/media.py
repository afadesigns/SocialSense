# Copyright (c) 2024. Lorem ipsum dolor sit amet, consectetur adipiscing elit.
# Morbi non lorem porttitor neque feugiat blandit. Ut vitae ipsum eget quam lacinia accumsan.
# Etiam sed turpis ac ipsum condimentum fringilla. Maecenas magna.
# Proin dapibus sapien vel ante. Aliquam erat volutpat. Pellentesque sagittis ligula eget metus.
# Vestibulum commodo. Ut rhoncus gravida arcu.

import json
import random
import time
from copy import deepcopy
from datetime import datetime
from typing import Dict, List, Optional, Tuple, Union
from urllib.parse import urlparse

import requests
from instagrapi import ClientError, ClientLoginRequired, ClientNotFoundError, MediaNotFound, PrivateError, extract_location, extract_media_gql, extract_media_oembed, extract_media_v1, extract_user_short, InstagramIdCodec, json_value

class MediaMixin:
    """
    Helpers for media
    """

    _medias_cache: dict = {}  # pk -> object

    def media_id(self, media_pk: str) -> str:
        """
        Get full media id

        Parameters
        ----------
        media_pk: str
            Unique Media ID

        Returns
        -------
        str
            Full media id

        Example
        -------
        2277033926878261772 -> 2277033926878261772_1903424587
        """
        media_id = str(media_pk)
        if "_" not in media_id:
            assert media_id.isdigit(), (
                "media_id must been contain digits, now %s" % media_id
            )
            user = self.media_user(media_id)
            media_id = "%s_%s" % (media_id, user.pk)
        return media_id

    @staticmethod
    def media_pk(media_id: str) -> str:
        """
        Get short media id

        Parameters
        ----------
        media_id: str
            Unique Media ID

        Returns
        -------
        str
            media id

        Example
        -------
        2277033926878261772_1903424587 -> 22770339268782617

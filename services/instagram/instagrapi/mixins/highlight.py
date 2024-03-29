import json
import random
import time
from pathlib import Path
from typing import Dict, List, Union
from urllib.parse import urlparse

from instagrapi import config
from instagrapi.exceptions import HighlightNotFound
from instagrapi.extractors import extract_highlight_v1
from instagrapi.types import Highlight
from instagrapi.utils import dumps


class HighlightMixin:
    def highlight_pk_from_url(self, url: str) -> str:
        """
        Get Highlight PK from URL

        Parameters
        ----------
        url: str
            URL of highlight

        Returns
        -------
        str
            Highlight PK

        Examples
        --------
        https://www.instagram.com/stories/highlights/17895485201104054/ -> 17895485201104054
        """
        assert "/highlights/" in url, 'URL must contain "/highlights/"'
        path = urlparse(url).path
        parts = [p for p in path.split("/") if p and p.isdigit()]
        return str(parts[-1]) if parts else ""

    def user_highlights_v1(self, user_id: str, amount: int = 0) -> List[Highlight]:
        """
        Get a user's highlight

        Parameters
        ----------
        user_id: str
        amount: int, optional
            Maximum number of highlight to return, default is 0 (all highlights)

        Returns
        -------
        List[Highlight]
            A list of objects of Highlight
        """
        amount = int(amount)
        user_id = int(user_id)
        params = {
            "supported_capabilities_new": json.dumps(config.SUPPORTED_CAPABILITIES),
            "phone_id": self.phone_id,
            "battery_level": random.randint(25, 100),
            "panavision_mode": "",
            "is_charging": random.randint(0, 1),
            "is_dark_mode": random.randint(0, 1),
            "will_sound_on": random.randint(0, 1),
        }
        result = self.private_request(
            f"highlights/{user_id}/highlights_tray/", params=params
        )
        return [extract_highlight_v1(highlight) for highlight in result.get("tray", [])]

    def user_highlights(self, user_id: str, amount: int = 0) -> List[Highlight]:
        """
        Get a user's highlights

        Parameters
        ----------
        user_id: str
        amount: int, optional
            Maximum number of highlight to return, default is 0 (all highlights)

        Returns
        -------
        List[Highlight]
            A list of objects of Highlight
        """
        return self.user_highlights_v1(user_id, amount)

    def highlight_info_v1(self, highlight_pk: str) -> Highlight:
        """
        Get Highlight by pk or id (by Private Mobile API)

        Parameters
        ----------
        highlight_pk: str
            Unique identifier of Highlight

        Returns
        -------
        Highlight
            An object of Highlight type

        Raises
        ------
        HighlightNotFound
            If the highlight was not found
        """
        highlight_id = f"highlight:{highlight_pk}"
        data = {
            "exclude_media_ids": "[]",
            "supported_capabilities_new": json.dumps(config.SUPPORTED_CAPABILITIES),
            "source": "profile",
            "_uid": str(self.user_id),
            "_uuid": self.uuid,
            "user_ids": [highlight_id],
        }
        result = self.private_request("feed/reels_media/", data)
        data = result["reels"]
        if highlight_id not in data:
            raise HighlightNotFound(highlight_pk=highlight_pk, **data)
        return extract_highlight_v1(data[highlight_id])

    def highlight_info(self, highlight_pk: str) -> Union[Highlight, None]:
        """
        Get Highlight by pk or id

        Parameters
        ----------
        highlight_pk: str
            Unique identifier of Highlight

        Returns
        -------
        Union[Highlight, None]
            An object of Highlight type or None if the highlight was not found
        """
        try:
            return self.highlight_info_v1(highlight_pk)
        except HighlightNotFound:
            return None

    def highlight_create(
        self,
        title: str,
        story_ids: List[str],
        cover_story_id: str = "",
        crop_rect: List[float] = [0.0, 0.21830457, 1.0, 0.78094524],
    ) -> Highlight:
        """
        Create highlight

        Parameters
        ----------
        title: str
            Title
        story_ids: List[str]
            List of story ids
        cover_story_id: str
            User story as cover, default is first of story_ids

        Returns
        -------
        Highlight
            An object of Highlight type
        """
        if not cover_story_id:
            cover_story_id = story_ids[0]
        data = {
            "supported_capabilities_new": json.dumps(config.SUPPORTED_CAPAB

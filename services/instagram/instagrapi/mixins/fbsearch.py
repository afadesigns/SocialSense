from typing import Dict, List, Tuple, Union

from instagrapi.extractors import (
    extract_hashtag_v1,
    extract_location,
    extract_track,
    extract_user_short,
)
from instagrapi.types import Hashtag, Location, Track, UserShort
from instagrapi import Client

class FbSearchMixin:
    def __init__(self, client: Client):
        self.client = client
        self.timezone_offset = client.timezone_offset

    def fbsearch_places(
        self, query: str, lat: float = 40.74, lng: float = -73.94
    ) -> List[Location]:
        """
        Searches for places near a given location.

        Parameters
        ----------
        query: str
            The search query.
        lat: float
            The latitude of the search location.
        lng: float
            The longitude of the search location.

        Returns
        -------
        List[Location]
            A list of Location objects representing the search results.
        """
        params = {
            "search_surface": "places_search_page",
            "timezone_offset": self.timezone_offset,
            "lat": lat,
            "lng": lng,
            "count": 30,
            "query": query,
        }
        result = self.client.private_request("fbsearch/places/", params=params)
        if not result.get("items"):
            return []
        locations = [extract_location(item["location"]) for item in result["items"]]
        return locations

    def fbsearch_topsearch_flat(self, query: str) -> List[dict]:
        """
        Searches for top search results.

        Parameters
        ----------
        query: str
            The search query.

        Returns
        -------
        List[dict]
            A list of dictionaries representing the search results.
        """
        params = {
            "search_surface": "top_search_page",
            "context": "blended",
            "timezone_offset": self.timezone_offset,
            "count": 30,
            "query": query,
        }
        result = self.client.private_request("fbsearch/topsearch_flat/", params=params)
        return result.get("list", [])

    def search_users(self, query: str) -> List[UserShort]:
        """
        Searches for users.

        Parameters
        ----------
        query: str
            The search query.

        Returns
        -------
        List[UserShort]
            A list of UserShort objects representing the search results.
        """
        params = {
            "search_surface": "user_search_page",
            "timezone_offset": self.timezone_offset,
            "count": 30,
            "q": query,
        }
        result = self.client.private_request("users/search/", params=params)
        return [extract_user_short(item) for item in result.get("users", [])]

    def search_music(self, query: str) -> List[Track]:
        """
        Searches for music.

        Parameters
        ----------
        query: str
            The search query.

        Returns
        -------
        List[Track]
            A list of Track objects representing the search results.
        """
        params = {
            "query": query,
            "browse_session_id": self.client.generate_uuid(),
        }
        result = self.client.private_request("music/audio_global_search/", params=params)
        return [extract_track(item["track"]) for item in result.get("items", [])]

    def search_hashtags(self, query: str) -> List[Hashtag]:
        """
        Searches for hashtags.

        Parameters
        ----------
        query: str
            The search query.

        Returns
        -------
        List[Hashtag]
            A list of Hashtag objects representing the search results.
        """
        params = {
            "search_surface": "hashtag_search_page",
            "timezone_offset": self.timezone_offset,
            "count": 30,
            "q": query,
        }
        result = self.client.private_request("tags/search/", params=params)
        return [extract_hashtag_v1(ht) for ht in result.get("results", [])]

    def fbsearch_suggested_profiles(self, user_id: str) -> List[UserShort]:
        """
        Searches for suggested profiles.

        Parameters
        ----------
        user_id: str
            The ID of the user to search for suggested profiles.

        Returns
        -------
        List[UserShort]
            A list of UserShort objects representing the search results.
        """
        params = {
            "target_user_id": user_id,
            "include_friendship_status": "true",
        }
        result = self.client.private_request("fbsearch/accounts_recs/", params=params)
        return result.get("users", [])

    def fbsearch_recent(self) -> List[Tuple[int, Union[UserShort, Hashtag, Dict]]]:
        """
        Retrieves recently searched results.

        Returns
        -------
        List[Tuple[int, Union[UserShort, Hashtag, Dict]]]
            Returns list of Tuples where first value is timestamp of searh, second is retrived result
        """
        result = self.client.private_request("fbsearch/recent_se

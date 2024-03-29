from typing import List

from instagrapi.extractors import extract_media_v1
from instagrapi.types import Media
from instagrapi.client import Client as InstaClient

class ReelsMixin:
    """
    Helpers for Reels
    """

    def __init__(self, client: InstaClient):
        self.client = client
        self.logger = client.logger

    def reels(self, amount: int = 10, last_media_pk: int = 0) -> List[Media]:
        """
        Get connected reels media

        Parameters
        ----------
        amount: int, optional
            Maximum number of media to return, default is 10
        last_media_pk: int, optional
            Last PK user has seen, function will return medias after this pk. Default is 0

        Returns
        -------
        List[Media]
            A list of objects of Media
        """
        return self.reels_timeline_media("reels", amount, last_media_pk)

    def explore_reels(self, amount: int = 10, last_media_pk: int = 0) -> List[Media]:
        """
        Get discover reels media

        Parameters
        ----------
        amount: int, optional
            Maximum number of media to return, default is 10
        last_media_pk: int, optional
            Last PK user has seen, function will return medias after this pk. Default is 0

        Returns
        -------
        List[Media]
            A list of objects of Media
        """
        return self.reels_timeline_media("explore_reels", amount, last_media_pk)

    def reels_timeline_media(
        self, collection_pk: str, amount: int = 10, last_media_pk: int = 0
    ) -> List[Media]:
        """
        Get reels timeline media in a collection

        Parameters
        ----------
        collection_pk: str
            Unique identifier of a timeline
        amount: int, optional
            Maximum number of media to return, default is 10
        last_media_pk: int, optional
            Last PK user has seen, function will return medias after this pk. Default is 0

        Returns
        -------
        List[Media]
            A list of objects of Media
        """
        private_request_endpoint = {
            "reels": "clips/connected/",
            "explore_reels": "clips/discover/",
        }.get(collection_pk)

        if not private_request_endpoint:
            raise ValueError(f"Invalid collection_pk value: {collection_pk}")

        total_items = []
        next_max_id = ""

        while len(total_items) < amount:
            try:
                result = self.client.private_request(
                    private_request_endpoint,
                    data=" ",
                    params={"max_id": next_max_id},
                )
            except Exception as e:
                self.logger.exception(e)
                return total_items

            if not result.get("items"):
                break

            for item in result["items"]:
                if last_media_pk and last_media_pk == item["media"]["pk"]:
                    return total_items
                total_items.append(extract_media_v1(item.get("media")))

                # Break the loop if the requested amount is reached
                if len(total_items) >= amount:
                    break

            if not result.get("paging_info", {}).get("more_available"):
                break

            next_max_id = result.get("paging_info", {}).get("more_available")

        return total_items

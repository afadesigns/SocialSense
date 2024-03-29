from typing import List, Tuple, Union

from instagrapi.exceptions import CollectionNotFound
from instagrapi.extractors import extract_collection, extract_media_v1
from instagrapi.types import Collection, Media
from instagrapi import Client as InstaGrapiClient

class CollectionMixin:
    """
    Helpers for collection
    """

    def __init__(self, client: InstaGrapiClient):
        self.client = client

    def collections(self) -> List[Collection]:
        """
        Get collections

        Returns
        -------
        List[Collection]
            A list of objects of Collection
        """
        next_max_id = ""
        total_items = []
        while True:
            try:
                result = self.client.private_request(
                    "collections/list/",
                    params={
                        "collection_types": '["ALL_MEDIA_AUTO_COLLECTION","PRODUCT_AUTO_COLLECTION","MEDIA"]',
                        "max_id": next_max_id,
                    },
                )
            except Exception as e:
                self.client.logger.exception(e)
                return total_items
            for item in result["items"]:
                total_items.append(extract_collection(item))
            if not result.get("more_available"):
                return total_items
            next_max_id = result.get("next_max_id", "")
        return total_items

    def collection_pk_by_name(self, name: str) -> int:
        """
        Get collection_pk by name

        Parameters
        ----------
        name: str
            Name of the collection

        Returns
        -------
        int
            The unique identifier of a Collection

        Raises
        ------
        CollectionNotFound
            If the collection is not found
        """
        for item in self.collections():
            if item.name == name:
                return item.id
        raise CollectionNotFound(name=name)

    def collection_medias_by_name(self, name: str) -> List[Collection]:
        """
        Get medias by collection name

        Parameters
        ----------
        name: str
            Name of the collection

        Returns
        -------
        List[Collection]
            A list of collections

        Raises
        ------
        CollectionNotFound
            If the collection is not found
        """
        collection_pk = self.collection_pk_by_name(name)
        try:
            return self.collection_medias(collection_pk)
        except CollectionNotFound:
            return []

    def liked_medias(self, amount: int = 21, last_media_pk: int = 0) -> List[Media]:
        """
        Get media you have liked

        Parameters
        ----------
        amount: int, optional
            Maximum number of media to return, default is 21
        last_media_pk: int, optional
            Last PK user has seen, function will return medias after this pk. Default is 0

        Returns
        -------
        List[Media]
            A list of objects of Media
        """
        return self.collection_medias("liked", amount, last_media_pk)

    def collection_medias_v1_chunk(
        self, collection_pk: str, max_id: str = ""
    ) -> Tuple[List[Media], str]:
        """
        Get media in a collection by collection_pk

        Parameters
        ----------
        collection_pk: str
            Unique identifier of a Collection
        max_id: str, optional
            Cursor

        Returns
        -------
        Tuple[List[Media], str]
            A list of objects of Media and cursor

        Raises
        ------
        ValueError
            If the collection_pk is not a valid type
        """
        if not isinstance(collection_pk, str):
            raise ValueError("collection_pk must be a string")

        if collection_pk.isdigit():
            private_request_endpoint = f"feed/collection/{collection_pk}/"
        elif collection_pk.lower() == "liked":
            private_request_endpoint = "feed/liked/"
        else:
            private_request_endpoint = "feed/saved/posts/"

        params = {"include_igtv_preview": "false"}
        if max_id:
            params["max_id"] = max_id
        result = self.client.private_request(private_request_endpoint, params=params)
        items = [extract_media_v1(m.get("media", m)) for m in result["items"]]
        return items, result.get("next_max_id", "")

    def collection_medias_v1(
        self, collection_pk: str, amount: int = 21, last_media_pk: int = 0
    ) -> List[Media]:
        """
        Get media in a collection by collection_pk

        Parameters
        ----------
        collection_pk: str
            Unique identifier of a Collection
        amount: int, optional
            Maximum number of media to return, default is 21
        last_media_pk: int, optional
            Last PK user has seen, function will return medias after this pk. Default is 0

        Returns
        -------
        List[Media]
            A list of objects of Media

        Raises
        ------
        ValueError
            If the collection

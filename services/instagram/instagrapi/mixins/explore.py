import requests

class ExploreMixin:
    """
    Helpers for the explore page
    """

    def __init__(self, session):
        self.session = session

    @property
    def explore_page(self):
        """
        Get explore page

        Returns
        -------
        dict
        """
        return self._private_request("discover/topical_explore/")

    def report_explore_media(self, media_id: int) -> bool:
        """
        Report media in explore page. This is equivalent to the "not interested" button

        Parameters
        ----------
        media_id: int
            Media ID

        Returns
        -------
        bool
            True if success
        """
        params = {
            "m_pk": media_id,
        }
        result = self._private_request("discover/explore_report/", params=params)
        return result["explore_report_status"] == "OK"

    def explore_page_media_info(self, media_id: int) -> dict:
        """
        Returns media information for a media item on the explore page

        This is the API call that happens when you're on the explore page
        and you click into a media item. It returns information about that media item
        like comments, likes, etc.

        Returns
        -------
        dict
            Media information
        """
        params = {
            "media_id": media_id,
        }
        response = self._private_request("/v1/discover/media_metadata/", params=params)
        media_info = response.get("media_or_ad")

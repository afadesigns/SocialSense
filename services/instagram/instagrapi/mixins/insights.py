import time
from typing import Dict, List, Literal, Optional

from instagrapi.exceptions import ClientError, MediaError, UserError
from instagrapi.utils import json_value

POST_TYPES: tuple[str, ...] = (
    "ALL",
    "CAROUSEL_V2",
    "IMAGE",
    "SHOPPING",
    "VIDEO",
)
TIME_FRAMES: tuple[str, ...] = (
    "ONE_WEEK",
    "ONE_MONTH",
    "THREE_MONTHS",
    "SIX_MONTHS",
    "ONE_YEAR",
    "TWO_YEARS",
)
DATA_ORDERS: tuple[str, ...] = (
    "REACH_COUNT",
    "LIKE_COUNT",
    "FOLLOW",
    "SHARE_COUNT",
    "BIO_LINK_CLICK",
    "COMMENT_COUNT",
    "IMPRESSION_COUNT",
    "PROFILE_VIEW",
    "VIDEO_VIEW_COUNT",
    "SAVE_COUNT",
)

try:
    from typing import Literal

    PostType = Literal[POST_TYPES]
    TimeFrame = Literal[TIME_FRAMES]
    DataOrdering = Literal[DATA_ORDERS]
except ImportError:
    # python <= 3.8
    PostType = TimeFrame = DataOrdering = str

class InsightsMixin:
    """
    Helper class to get insights
    """

    def __init__(self):
        self.last_json: Optional[Dict] = None

    def _get_query_params(
        self,
        data: Dict,
        query_params: Dict,
        *,
        count: int = 200,
        cursor: Optional[str] = None,
    ) -> Dict:
        params = {**query_params, **{"count": count}}
        if cursor:
            params["cursor"] = cursor
        return {**data, **params}

    def _get_result(self, url: str, query_params: Dict) -> Dict:
        self.last_json = self.private_request(url, query_params)
        self.raise_for_status()
        return self.last_json

    def raise_for_status(self):
        if self.last_json and self.last_json.get("status") != "ok":
            raise UserError(self.last_json.get("message"))

    def insights_media_feed_all(
        self,
        post_type: PostType = "ALL",
        time_frame: TimeFrame = "TWO_YEARS",
        data_ordering: DataOrdering = "REACH_COUNT",
        count: int = 0,
    ) -> List[Dict]:
        assert (
            post_type in POST_TYPES
        ), f'Unsupported post_type="{post_type}" {POST_TYPES}'
        assert (
            time_frame in TIME_FRAMES
        ), f'Unsupported time_frame="{time_frame}" {TIME_FRAMES}'
        assert (
            data_ordering in DATA_ORDERS
        ), f'Unsupported data_ordering="{data_ordering}" {DATA_ORDERS}'
        assert self.user_id, "Login required"
        medias = []
        cursor = None
        data = {
            "surface": "post_grid",
            "doc_id": 2345520318892697,
            "locale": "en_US",
            "vc_policy": "insights_policy",
            "strip_nulls": False,
            "strip_defaults": False,
        }
        query_params = {
            "IgInsightsGridMediaImage_SIZE": 480,
            "count": 200,  # TODO Try to detect max allowed value
            "dataOrdering": data_ordering,
            "postType": post_type,
            "timeframe": time_frame,
            "search_base": "USER",
            "is_user": "true",
            "queryParams": {"access_token": "", "id": self.user_id},
        }
        while True:
            query_params = self._get_query_params(data, query_params, cursor=cursor)
            result = self._get_result("ads/graphql/", query_params)
            if not json_value(
                result,
                "data",
                "shadow_instagram_user",
                "business_manager",
                default=None,
            ):
                raise UserError("Account is not business account", **result)
            stats = json_value(
                result,
                "data",
                "shadow_instagram_user",
                "business_manager",
                "top_posts_unit",
                "top_posts",
            )
            cursor = stats["page_info"]["end_cursor"]
            medias.extend(stats["edges"])
            if not stats["page_info"]["has_next_page"]:
                break
            if count and len(medias) >= count:
                break
            time.sleep(2)
        if count:


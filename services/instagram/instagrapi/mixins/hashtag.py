import base64
import json
from functools import lru_cache
from typing import List, Tuple, Union

import requests
from typing_extensions import TypedDict

from instagrapi.exceptions import (
    ClientError,
    ClientLoginRequired,
    ClientUnauthorizedError,
    HashtagNotFound,
    WrongCursorError,
)
from instagrapi.extractors import (
    extract_hashtag_gql,
    extract_hashtag_v1,
    extract_media_v1,
)
from instagrapi.types import Hashtag, Media
from instagrapi.utils import dumps

class MediaData(TypedDict):
    media_id: str
    caption_text: str



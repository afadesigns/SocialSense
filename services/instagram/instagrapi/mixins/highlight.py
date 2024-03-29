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
        https://www.instagram.com/stories/highlights/17895485201104054/ -> 1789548

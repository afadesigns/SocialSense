import random
import re
import time
from pathlib import Path
from typing import Any, Dict, List, Literal, Optional, Tuple, Union

import instagrapi.exceptions
from instagrapi.extractors import (
    extract_direct_media,
    extract_direct_message,
    extract_direct_short_thread,
    extract_direct_thread,
    extract_user_short,
)
from instagrapi.types import (
    DirectMessage,
    DirectShortThread,
    DirectThread,
    Media,
    UserShort,
)
from instagrapi.utils import dumps

SELECTED_FILTERS = ("flagged", "unread")
SEARCH_MODES = ("raven", "universal")
SEND_ATTRIBUTES = ("message_button", "inbox_search")
SEND_ATTRIBUTES_MEDIA = (
    "feed_timeline",
    "feed_contextual_chain",


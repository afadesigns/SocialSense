import datetime
import enum
import json
import random
import string
import time
import urllib.parse
from typing import Any, Dict, List, Optional, Union


class InstagramIdCodec:
    ENCODING_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"

    @staticmethod
    def encode(num: int, alphabet: str = ENCODING_CHARS) -> str:
        """Convert a numeric value to a shortcode."""
        if num == 0:
            return alphabet[0]
        arr: list = []
        base: int = len(alphabet)
        while num:
            rem: int = num % base
            num //= base
            arr.append(alphabet[rem])
        arr.reverse()
        return "".join(arr)

    @staticmethod
    def decode(shortcode: str, alphabet: str = ENCODING_CHARS) -> int:
        """Convert a shortcode to a numeric value."""
        base: int = len(alphabet)
        strlen: int = len(shortcode)
        num: int = 0
        idx: int = 0
        for char in shortcode:
            power: int = strlen - (idx + 1)
            num += alphabet.index(char) * (base**power)
            idx += 1
        return num


class InstagrapiJSONEncoder(json.JSONEncoder):
    """JSON encoder for Instagrapi with custom serialization for some types."""

    def default(self, obj: Any) -> Union[str, int, List[Any], Dict[str, Any]]:
        if isinstance(obj, enum.Enum):
            return obj.value
        elif isinstance(obj, datetime.time):
            return obj.strftime("%H:%M")
        elif isinstance(obj, (datetime.datetime, datetime.date)):
            return int(obj.strftime("%s"))
        elif isinstance(obj, set):
            return list(obj)
        return json.JSONEncoder.default(self, obj)


def generate_signature(data: str) -> str:
    """Generate signature of POST data for Private API

    Returns
    -------
    str
        e.g. "signed_body=SIGNATURE.test"
    """
    return f"signed_body=SIGNATURE.{urllib.parse.quote_plus(data)}"


def json_value(data: Dict[str, Any], *args: str, default: Optional[Any] = None) -> Any:
    """Retrieve a value from a JSON object by nested keys/indices.

    Args:
        data (Dict[str, Any]): JSON object
        *args (str): Keys or indices to access the value
        default (Optional[Any]): Default value to return if the value is not found

    Returns:
        Any: The value if found, otherwise default
    """
    cur: Any = data
    for a in args:
        try:
            if isinstance(a, int):
                cur = cur[a]
            else:
                cur = cur.get(a)
        except (IndexError, KeyError, TypeError, AttributeError):
            return default
    return cur

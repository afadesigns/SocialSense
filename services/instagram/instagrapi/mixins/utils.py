import datetime
import enum
import json
import random
import secrets
import string
import time
import urllib.parse
from typing import Any
from typing import Callable
from typing import List
from typing import Optional


class InstagramIdCodec:
    """Convert numeric values to shortcodes and vice versa.

    This class provides methods for encoding and decoding numeric values to
    shortcodes and vice versa. The shortcodes are generated using a set of
    encoding characters that can be customized.

    Attributes:
        ENCODING_CHARS (str): The default set of encoding characters.
    """

    ENCODING_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"

    @staticmethod
    def encode(num: int, alphabet: str = ENCODING_CHARS) -> str:
        """Convert a numeric value to a shortcode.

        Args:
            num (int): The numeric value to encode.
            alphabet (str, optional): The set of encoding characters.
                Defaults to ENCODING_CHARS.

        Returns:
            str: The encoded shortcode.
        """
        if num == 0:
            return alphabet[0]

        arr: List[str] = []
        base: int = len(alphabet)
        while num:
            rem: int = num % base
            num //= base
            arr.append(alphabet[rem])
        arr.reverse()
        return "".join(arr)

    @staticmethod
    def decode(shortcode: str, alphabet: str = ENCODING_CHARS) -> int:
        """Convert a shortcode to a numeric value.

        Args:
            shortcode (str): The shortcode to decode.
            alphabet (str, optional): The set of encoding characters.
                Defaults to ENCODING_CHARS.

        Returns:
            int: The decoded numeric value.
        """
        base: int = len(alphabet)
        strlen: int = len(shortcode)
        num: int = 0
        idx: int = 0
        for char in shortcode:
            power: int = strlen - (idx + 1)
            num += alphabet.index(char) * (base**power)
            idx += 1
        return num


def json_value(data: dict, *args: str, default: Optional[Any] = None) -> Any:
    """Get a value from a JSON object.

    Args:
        data (dict): The JSON object.
        *args (str): The keys of the value to get.
        default (Any, optional): The default value if the key does not exist.
            Defaults to None.

    Returns:
        Any: The value of the key or the default value.
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


def generate_signature(data: str) -> str:
    """Generate a signature for a POST request.

    Args:
        data (str): The POST data.

    Returns:
        str: The signature string.
    """
    return f"signed_body=SIGNATURE.{urllib.parse.quote_plus(data)}"


def gen_token(size: int = 10, symbols: bool = False) -> str:
    """Generate a random token.

    Args:
        size (int, optional): The length of the token. Defaults to 10.
        symbols (bool, optional): Whether to include symbols in the token.
            Default

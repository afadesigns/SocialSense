import datetime
import enum
import random
import string
import time
import urllib
from typing import Any
from typing import Dict
from typing import List
from typing import Optional
from typing import Union


class InstagramIdCodec:
    ENCODING_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"

    @staticmethod
    def encode(num: int, alphabet: str = ENCODING_CHARS) -> str:
        """Convert a numeric value to a shortcode.

        Args:
            num (int): The numeric value to encode.
            alphabet (str, optional): The alphabet to use for encoding. Defaults to ENCODING_CHARS.

        Returns:
            str: The encoded shortcode.
        """
        num = int(num)
        if num == 0:
            return alphabet[0]
        arr = []
        base = len(alphabet)
        while num:
            rem = num % base
            num //= base
            arr.append(alphabet[rem])
        arr.reverse()
        return "".join(arr)

    @staticmethod
    def decode(shortcode: str, alphabet: str = ENCODING_CHARS) -> int:
        """Convert a shortcode to a numeric value.

        Args:
            shortcode (str): The shortcode to decode.
            alphabet (str, optional): The alphabet to use for decoding. Defaults to ENCODING_CHARS.

        Returns:
            int: The decoded numeric value.
        """
        base = len(alphabet)
        strlen = len(shortcode)
        num = 0
        idx = 0
        for char in shortcode:
            power = strlen - (idx + 1)
            num += alphabet.index(char) * (base**power)
            idx += 1
        return num


class InstagrapiJSONEncoder(json.JSONEncoder):
    def default(self, obj: Any) -> Union[str, List[str], int]:
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

    Returns:
        str: The generated signature.
    """
    return f"signed_body=SIGNATURE.{urllib.parse.quote_plus(data)}"


def json_value(data: Dict[str, Any], *args: List[str], default: Optional[Any] = None) -> Any:
    cur = data
    for a in args:
        try:
            if isinstance(a, int):
                cur = cur[a]
            else:
                cur = cur.get(a)
        except (IndexError, KeyError, TypeError, AttributeError):
            return default
    return cur


def gen_token(size: int = 10, symbols: bool = False) -> str:
    """Gen CSRF or something else token

    Returns:
        str: The generated token.
    """
    chars = string.ascii_letters + string.digits
    if symbols:
        chars += string.punctuation
    return "".join(random.choice(chars) for _ in range(size))


def gen_password(size: int = 10) -> str:
    """Gen password

    Returns:
        str: The generated password.
    """
    return gen_token(size)


def dumps(data: Any) -> str:
    """Json dumps format as required Instagram

    Returns:
        str: The JSON-formatted data.
    """
    return InstagrapiJSONEncoder(separators=(",", ":")).encode(data)


def generate_jazoest(symbols: str) -> str

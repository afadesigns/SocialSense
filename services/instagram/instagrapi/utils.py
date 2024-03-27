import datetime
import enum
import json
import random
import string
import time
import urllib


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
        if num == 0:
            return alphabet[0]

        base = len(alphabet)
        result = []

        while num:
            rem = num % base
            num //= base
            result.append(alphabet[rem])

        result.reverse()
        return "".join(result)

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
        length = len(shortcode)
        num = 0

        for i, char in enumerate(shortcode):
            power = length - (i + 1)
            num += alphabet.index(char) * (base**power)

        return num


class InstagrapiJSONEncoder(json.JSONEncoder):
    def default(self, obj):
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
    """Generate signature of POST data for Private API.

    Args:
        data (str): The POST data to generate the signature for.

    Returns:
        str: The generated signature.
    """
    return f"signed_body=SIGNATURE.{urllib.parse.quote_plus(data)}"


def json_value(data: dict, *args, default=None) -> any:
    """Get the value of a nested key in a JSON object.

    Args:
        data (dict): The JSON object to get the value from.
        *args: The keys to access in the JSON object.
        default: The default value to return if the key is not found.

    Returns:
        any: The value of the nested key or the default value.
    """
    cur = data
    for arg in args:
        try:
            cur = cur[arg]
        except (IndexError, KeyError, TypeError, AttributeError):
            return default
    return cur


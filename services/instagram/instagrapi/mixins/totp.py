import base64
import datetime
import hashlib
import hmac
import time
from typing import Any, List, Optional


class TOTP:
    """
    Base class for OTP handlers.
    """

    def __init__(
        self,
        s: str,
        digits: int = 6,
        digest: Any = hashlib.sha1,
        name: Optional[str] = None,
        issuer: Optional[str] = None,
    ) -> None:
        """
        Initialize TOTP object with a secret key.

        :param s: The secret key in base32 format.
        :param digits: Number of digits in the OTP (default: 6).
        :param digest: The hash function to use (default: SHA-1).
        :param name: Name of the OTP (default: "Secret").
        :param issuer: Issuer of the OTP (default: None).
        """
        self.digits = digits
        self.digest = digest
        self.secret = s
        self.name = name or "Secret"
        self.issuer = issuer
        self.interval = 30

    def generate_otp(self, input: int) -> str:
        """
        Generate an OTP using HMAC-SHA1.

        :param input: The HMAC counter value to use as the OTP input.
        :return: The generated OTP as a string.
        """
        if input < 0:
            raise ValueError("input must be positive integer")
        hasher = hmac.new(
            self.byte_secret(), self.int_to_bytestring(input), self.digest
        )
        hmac_hash = bytearray(hasher.digest())
        offset = hmac_hash[-1] & 0xF
        code = (
            (hmac_hash[offset] & 0x7F) << 24
            | (hmac_hash[offset + 1] & 0xFF) << 16
            | (hmac_hash[offset + 2] & 0xFF) << 8
            | (hmac_hash[offset + 3] & 0xFF)
        )
        str_code = str(code % 10**self.digits)
        while len(str_code) < self.digits:
            str_code = "0" + str_code
        return str_code

    def byte_secret(self) -> bytes:
        """
        Return the secret key as a byte string.

        :return: The secret key as a byte string.
        """
        secret = self.secret
        missing_padding = len(secret) % 8
        if missing_padding != 0:
            secret += "=" * (8 - missing_padding)
        return base64.b32decode(secret, casefold=True)

    @staticmethod
    def int_to_bytestring(i: int, padding: int = 8) -> bytes:
        """
        Turn an integer to the OATH specified bytestring.

        :param i: The integer to convert.
        :param padding: The number of padding bytes (default: 8).
        :return: The bytestring representation of the integer.
        """
        result = bytearray()
        while i != 0:
            result.append(i & 0xFF)
            i >>= 8
        return bytes(bytearray(reversed(result)).rjust(padding, b"\0"))

    def code(self) -> str:
        """
        Generate a TOTP code.

        :return: The generated TOTP code as a string.
        """
        now = datetime.datetime.now()
        timecode = int(time.mktime(now.timetuple()) / self.interval)
        return self.generate_otp(timecode)


class TOTPHandlersMixin:
    def totp_generate_seed(self) -> str:
        """
        Generate a TOTP seed.

        :return: The generated TOTP seed as a string.
        """
        # Implement this method in the subclass
        pass

    def totp_enable(self, verification_code: str) -> List[str]:
        """
        Enable TOTP 2FA.

        :param verification_code: The verification code.
        :return: The backup codes as a list of strings.
        """
        # Implement this method in the subclass
        pass

    def totp_disable(self) -> bool:
        """
        Disable TOTP 2FA.

        :return: True if successful, False otherwise.
        """
        # Implement this method in the subclass
        pass

    def totp_generate_code(self, seed: str) -> str:
        """
        Generate a TOTP code.

        :param seed: The TOTP seed.
        :return: The generated TOTP code as a string.
        """
        totp = TOTP(seed)
        return totp.code()

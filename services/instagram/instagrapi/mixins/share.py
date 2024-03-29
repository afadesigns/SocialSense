import base64
import re
from urllib.parse import urlparse
from typing import Optional, Union

from instagrapi.types import Share

class ShareMixin:
    def share_info(self, code: Union[str, bytes]) -> Share:
        """
        Get Share object by code

        Parameters
        ----------
        code: str or bytes
            Share code

        Returns
        -------
        Share
            Share object

        Raises
        ------
        ValueError
            If the `code` parameter is not a valid share code
        """
        if isinstance(code, str):
            try:
                code = code.encode()
            except UnicodeEncodeError:
                raise ValueError("Invalid share code")

        data = (
            base64.b64decode(code)
            .decode(errors="ignore")
            .replace("\x1d", "")
            .split(":")
        )
        if len(data) != 2:
            raise ValueError("Invalid share code")

        return Share(type=data[0], pk=data[1])

    def share_info_by_url(self, url: str) -> Optional[Share]:
        """
        Get Share object by URL

        Parameters
        ----------
        url: str
            URL of the share object

        Returns
        -------
        Share or None
            Share object or None if the URL is not a valid share URL
        """
        try:
            if not url.lower().startswith("http"):
                raise ValueError("Invalid URL")

            parsed_url = urlparse(url)
            if parsed_url.scheme != "http" and parsed_url.scheme != "https":
                raise ValueError("Invalid URL")

            code = self.share_code_from_url(url)
            return self.share_info(code)
        except (ValueError, IndexError):
            return None

    def share_code_from_url(self, url: str) -> str:
        """
        Get Share code from URL

        Parameters
        ----------
        url: str
            URL of the share object

        Returns
        -------
        str
            Share code

        Raises
        ------
        ValueError
            If the `url` parameter is not a valid share URL
        """
        match = re.search(r"/p/(\w+)/", url)
        if not match:
            raise ValueError("Invalid URL")

        return match.group(1)

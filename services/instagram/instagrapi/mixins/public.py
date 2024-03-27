import json
import logging
import time
import typing as ty

try:
    from simplejson.errors import JSONDecodeError
except ImportError:
    from json.decoder import JSONDecodeError

import requests
from requests.adapters import HTTPAdapter
from requests.packages.urllib3.util.retry import Retry
from typing import Any, Dict, Optional

from instagrapi.exceptions import (
    ClientBadRequestError,
    ClientConnectionError,
    ClientError,
    ClientForbiddenError,
    ClientGraphqlError,
    ClientIncompleteReadError,
    ClientJSONDecodeError,
    ClientLoginRequired,
    ClientNotFoundError,
    ClientThrottledError,
    ClientUnauthorizedError,
)
from instagrapi.utils import random_delay


class PublicRequestMixin:
    public_requests_count: int = 0
    PUBLIC_API_URL: str = "https://www.instagram.com/"
    GRAPHQL_PUBLIC_API_URL: str = "https://www.instagram.com/graphql/query/"
    last_public_response: Optional[requests.Response] = None
    last_public_json: Dict[str, Any] = {}
    public_request_logger: logging.Logger = logging.getLogger("public_request")
    request_timeout: float = 1
    last_response_ts: float = 0

    def __init__(
        self,
        *args,
        **kwargs,
    ) -> None:
        session = requests.Session()
        retry_strategy = Retry(
            total=3,
            status_forcelist=[429, 500, 502, 503, 504],
            allowed_methods=["GET", "POST"],
            backoff_factor=2,
        )
        adapter = HTTPAdapter(max_retries=retry_strategy)
        session.mount("https://", adapter)
        session.mount("http://", adapter)
        self.public = session
        self.public.verify = False  # fix SSLError/HTTPSConnectionPool
        self.public.headers.update(
            {
                "Connection": "Keep-Alive",
                "Accept": "*/*",
                "Accept-Encoding": "gzip,deflate",
                "Accept-Language": "en-US",
                "User-Agent": (
                    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/605.1.15 "
                    "(KHTML, like Gecko) Version/11.1.2 Safari/605.1.15"
                ),
            }
        )
        self.request_timeout = kwargs.pop("request_timeout", self.request_timeout)
        super().__init__(*args, **kwargs)

    def public_request(
        self,
        url: str,
        data: Optional[ty.Any] = None,
        params: Optional[ty.Any] = None,
        headers: Optional[ty.Any] = None,
        return_json: bool = False,
        retries_count: int = 3,
        retries_timeout: int = 2,
    ) -> ty.Any:
        kwargs = dict(
            data=data,
            params=params,
            headers=headers,
            return_json=return_json,
        )
        assert 0 <= retries_count <= 10, "Retries count is too high"
        assert 0 <= retries_timeout <= 600, "Retries timeout is too high"
        for iteration in range(retries_count):
            try:
                if self.delay_range:
                    random_delay(delay_range=self.delay_range)
                response = self._send_public_request(url, **kwargs)
                if not response:
                    continue
                if response.status_code in (
                    401,
                    403,
                    400,
                    429,
                    404,
                ):
                    raise ClientError(
                        response=response,
                    )
                if return_json:
                    self.last_public_json = response.json()
                    return self.last_public_json
                return response.text
            except (
                ClientLoginRequired,
                ClientNotFoundError,
                ClientBadRequestError,
            ) as e:
                raise e  # Stop retries
            except JSONDecodeError as e:
                raise ClientJSONDecodeError(
                    e, respones=self.last_public_response
                )
            except ClientError as

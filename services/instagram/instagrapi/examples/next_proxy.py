import random
import time

from requests.exceptions import ProxyError
from urllib3.exceptions import HTTPError

from instagrapi import Client
from instagrapi.exceptions import (
    ClientConnectionError,
    ClientForbiddenError,
    ClientLoginRequired,
    ClientThrottledError,
    GenericRequestError,
    PleaseWaitFewMinutes,
    RateLimitError,
    SentryBlock,
)

PROXY_LIST = [
    "http://username:password@147.123123.123:412345",
    "http://username:password@147.123123.123:412346",
    "http://username:password@147.123123.123:412347",
]

def get_proxy():
    return random.choice(PROXY_LIST)

def handle_network_error(cl):
    print("Network error, retrying with a new proxy...")
    cl.set_proxy(get_proxy())
    return cl

def handle_instagram_limit_error(cl):
    print("Instagram limit error, retrying with a new proxy in 5 minutes...")
    time.sleep(300)
    cl.set_proxy(get_proxy())
    return cl

def handle_logical_error(cl):
    print("Logical error, retrying with a new proxy...")
    cl.set_proxy(get_proxy())
    return cl

def main():
    cl = Client(proxy=get_proxy())

    for _ in range(3):
        try:
            cl.login("USERNAME", "PASSWORD")
            break
        except (ProxyError, HTTPError, GenericRequestError, ClientConnectionError) as e:
            cl = handle_network_error(cl)
        except (SentryBlock, RateLimitError, ClientThrottledError) as e:
            cl = handle_instagram_limit_error(cl

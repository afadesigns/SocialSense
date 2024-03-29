import os
import time
from typing import Dict, List, Union

from instagrapi import Client


def get_env_var(name: str, default: str = None) -> str:
    """
    Get environment variable or return a default value
    """
    var = os.getenv(name)
    if var is None:
        if default is not None:
            return default
        else:
            raise Exception(f"Environment variable {name} is not set")
    return var


def main(username: str, amount: int = 5) -> Dict[str, List[str]]:
    """
    Download all medias from Instagram profile
    """
    amount = int(amount)
    if amount < 0:
        raise ValueError("Amount must be non-negative")

    cl = Client()
    ACCOUNT_USERNAME = get_env_var("IG_USERNAME")
    ACCOUNT_PASSWORD = get_env_var("IG_PASSWORD")

    try:
        cl.login(ACCOUNT_USERNAME, ACCOUNT_PASSWORD, timeout=10)
    except Exception as e:
        raise Exception("Failed to login to Instagram account") from e

    user_id = cl.user_id_from_username(username)
    medias = cl.user_medias(user_id)
    result = {}
    i = 0
    for m in medias:
        if i >= amount:
            break
        paths = []
        media_type = m.media_type
        if media_type == 1:
            # Photo
            paths.append(cl.photo_download(m.pk))
        elif media_type == 2:
            product_type = m.product_type
            if product_type == "feed":
                # Video
                paths.append(cl.video_download(m.pk))
            elif product_type == "igtv":
                # IGTV
                paths.append(cl.video_download(m.

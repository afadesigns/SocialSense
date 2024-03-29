import os
import sys
import time
import random
import itertools
import pathlib
import argparse
import logging.config
from collections import deque
from contextlib import ExitStack
from typing import Final, List, Optional

import instagrapi
from instagrapi.types import Media

HASHTAGS: Final = ["instacool"]
HT_TYPE: Final = "top"
AMOUNT: Final = 27
LIKE_COUNT_MIN: Final = 1
DAYS_AGO_MAX: Final = 365
CREDENTIAL_PATH: Final = pathlib.Path("credential.json")

LOGGING_CONFIG: Final = {
    "version": 1,
    "disable_existing_loggers": False,
    "formatters": {
        "standard": {
            "format": "%(asctime)s %(levelname)s %(name)s: %(message)s",
        },
    },
    "handlers": {
        "default": {
            "class": "logging.StreamHandler",
            "formatter": "standard",
            "level": "DEBUG",
        },
    },
    "loggers": {
        "example_media": {
            "handlers": ["default"],
            "level": "DEBUG",
            "propagate": True,
        },
    },
}


def get_logger(name: str) -> logging.Logger:
    logging.config.dictConfig(LOGGING_CONFIG)
    logger = logging.getLogger(name)
    logger.debug(f"start logging '{name}'")
    return logger


def filter_medias(
    medias: List[Media],
    like_count_min: Optional[int] = None,
    like_count_max: Optional[int] = None,
    comment_count_min: Optional[int] = None,
    comment_count_max: Optional[int] = None,
    days_ago_max: Optional[int] = None,
) -> List[Media]:
    now = time.monotonic()
    queue: deque = deque(maxlen=len(medias))

    for media in medias:
        if like_count_min is not None and media.like_count < like_count_min:
            continue
        if like_count_max is not None and media.like_count > like_count_max:
            continue
        if comment_count_min is not None and media.comment_count < comment_count_min:
            continue
        if comment_count_max is not None and media.comment_count > comment_count_max:
            continue
        if days_ago_max is not None:
            queue.append((media, now - media.taken_at))
            if queue[-1][1] > timedelta(days=days_ago_max).total_seconds():
                continue
        yield media


def get_medias(
    hashtags: List[str],
    ht_type: str = HT_TYPE,
    amount: int = AMOUNT,
) -> List[Media]:
    medias: List[Media] = []
    with ExitStack() as stack:
        cl = stack.enter_context(instagrapi.Client())
        if stack.callback(cl.load_settings, CREDENTIAL_PATH):
            stack.enter_context(cl.login(IG_USERNAME, IG_PASSWORD))
        else:
            stack.enter_context(cl.login(IG_USERNAME, IG_PASSWORD))
            stack.enter_context(cl.dump_settings, CREDENTIAL_PATH)

        for hashtag in hashtags:
            if ht_type == "top":
                medias.extend(
                    cl.hashtag_medias_top(name=hashtag, amount=min(amount, 9))
                )
            elif ht_type == "recent":
                medias.extend(cl.hashtag_medias_recent

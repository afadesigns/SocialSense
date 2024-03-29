import io
import os
import re
import shutil
import tempfile
import typing
from urllib.request import urlretrieve

import requests
from PIL import Image
from moviepy.video.fx.all import crop, resize
from moviepy.video.io.VideoFileClip import VideoFileClip


def download_file(url: str, output_path: str) -> None:
    """
    Download a file from a URL and save it to a local path.

    :param url: The URL of the file to download.
    :param output_path: The local path to save the downloaded file.
    """
    response = requests.get(url, stream=True, timeout=5)
    response.raise_for_status()

    with open(output_path, "wb") as f:
        shutil.copyfileobj(response.raw, f)


def get_aspect_ratio(width: int, height: int) -> float:
    """
    Get the aspect ratio of an image or video.

    :param width: The width of the image or video.
    :param height: The height of the image or video.
    :return: The aspect ratio as a float.
    """
    return width / height


def calc_resize(
    max_size: typing.Tuple[int, int],
    curr_size: typing.Tuple[int, int],
    min_size: typing.Tuple[int, int] = (0, 0),
) -> typing.Tuple[int, int]:
    """
    Calculate if resize is required based on the max size desired
    and the current size

    :param max_size: tuple of (width, height)
    :param curr_size: tuple of (width, height)
    :param min_size: tuple of (width, height)
    :return:
    """
    max_width, max_height = max_size or (0, 0)
    min_width, min_height = min_size or (0, 0)

    if (max_width and min_width > max_width) or (
        max_height and min_height > max_height
    ):
        raise ValueError("Invalid min / max sizes.")

    orig_width, orig_height = curr_size
    if (
        max_width
        and max_height
        and (orig_width > max_width or orig_height > max_height)
    ):
        resize_factor = min(
            1.0 * max_width / orig_width, 1.0 * max_height / orig_height
        )
        new_width = int(resize_factor * orig_width)
        new_height = int(resize_factor * orig_height)
        return new_width, new_height

    elif (
        min_width
        and min_height
        and (orig_width < min_width or orig_height < min_height)
    ):
        resize_factor = max(
            1.0 * min_width / orig_width, 1.0 * min_height / orig_height
        )
        new_width = int(resize_factor * orig_width)
        new_height = int(resize_factor * orig_height)
        return new_width, new_height


def calc_crop(
    aspect_ratios: typing.Union[float, typing.Tuple[float, float]],
    curr_size: typing.Tuple[int, int],
) -> typing.Optional[typing.Tuple[int, int, int, int]]:
    """
    Calculate if cropping is required based on the desired aspect
    ratio and the current size.

    :param aspect_ratios: single float value or tuple of (min_ratio, max_ratio)
    :param curr_size: tuple of (width, height)
    :return:
    """
    try:
        if len(aspect_ratios) == 2:
            min_aspect_ratio = float(aspect_ratios[0])
            max_aspect_ratio = float(aspect_ratios[1])
        else:
            raise ValueError("Invalid aspect ratios")
    except TypeError:
        # not a min-max range
        min_aspect_ratio = float(aspect_ratios)
        max_aspect_ratio = float(aspect_ratios)

    curr_aspect_ratio = get_aspect_ratio(curr_size[0], curr_size[1])
    if not min_aspect_ratio <= curr_aspect_ratio <= max_aspect_ratio:
        curr_width = curr_size[0]
        curr_height = curr_size[1]
        if curr_aspect_ratio > max_aspect_ratio:
            # media is too wide
            new_height = curr_height
            new_width = max_aspect_ratio * new_height
        else:
            # media is too tall
            new_width = curr_width
            new_height = new_width / min_aspect_ratio
        left = int((curr_width - new_width) / 2)
        top = int((curr_height - new_height) / 2)
        right = int((curr_width + new_width) / 2)
        bottom = int((curr_height + new_height) / 2)
        return left, top, right, bottom


def is_remote(media: str) -> bool:
    """Detect if media specified is a url"""
    if re.match(r"^https?://", media):
        return True
    return False


def prepare_image(
    img: str,
    max_size: typing.Tuple[int, int] = (1080, 1350),
    aspect_rat

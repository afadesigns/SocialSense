import os
import sys
import random
import time
from pathlib import Path
from typing import Dict, List, Union
from urllib.parse import urlparse
from uuid import uuid4

import requests
try:
    import moviepy.editor as mp
except ImportError:
    raise Exception("Please install moviepy>=1.0.3 and retry")

from instagrapi import config
from instagrapi.exceptions import (
    VideoConfigureError,
    VideoConfigureStoryError,
    VideoNotDownload,
    VideoNotUpload,
)
from instagrapi.extractors import extract_direct_message, extract_media_v1
from instagrapi.types import (
    DirectMessage,
    Location,
    Media,
    Story,
    StoryHashtag,
    StoryLink,
    StoryLocation,
    StoryMention,
    StorySticker,
    Usertag,
)
from instagrapi.utils import date_time_original, dumps


class DownloadVideoMixin:
    """
    Helpers for downloading video
    """

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.request_timeout = 60

    def video_download(self, media_pk: int, folder: Union[str, Path] = "") -> Path:
        """
        Download video using media pk

        Parameters
        ----------
        media_pk: int
            Unique Media ID
        folder: Union[str, Path], optional
            Directory in which you want to download the video, default is "" and will download the files to working dir.

        Returns
        -------
        Path
            Path for the file downloaded
        """
        media = self.media_info(media_pk)
        assert media.media_type == 2, "Must been video"
        filename = "{username}_{media_pk}".format(
            username=media.user.username, media_pk=media_pk
        )
        return self.video_download_by_url(media.video_url, filename, folder)

    def video_download_by_url(
        self, url: str, filename: str = "", folder: Union[str, Path] = ""
    ) -> Path:
        """
        Download video using URL

        Parameters
        ----------
        url: str
            URL for a media
        filename: str, optional
            Filename for the media
        folder: Union[str, Path], optional
            Directory in which you want to download the video, default is "" and will download the files to working
                directory

        Returns
        -------
        Path
            Path for the file downloaded
        """
        url = str(url)
        fname = urlparse(url).path.rsplit("/", 1)[1]
        filename = "%s.%s" % (filename, fname.rsplit(".", 1)[1]) if filename else fname
        path = Path(folder) / filename
        response = requests.get(url, stream=True, timeout=self.request_timeout)
        response.raise_for_status()
        try:
            content_length = int(response.headers.get("Content-Length"))
        except (TypeError, KeyError):
            print(
                """
                The program detected an issue with the link, and hence can't download it.
                This problem occurs when the URL is passed into
                    'video_download_by_url()' or the 'clip_download_by_url()'.
                The raw URL needs to be re-formatted into one that is recognizable by the methods.
                Use this code: url=self.cl.media_info(self.cl.media_pk_from_url('insert the url here')).video_url
                You can remove the 'self' from the code above if needed.
                """
            )
            raise VideoNotDownload(
                f'Broken file from url "{url}" (Content-length not found in headers)'
            )
        file_length = len(response.content)
        if content_length != file_length:
            raise VideoNotDownload(
                f'Broken file from url "{url}" (Content-length={content_length}, but file length={file_length})'
            )
        if not path.parent.exists():
            path.parent.mkdir(parents=True, exist_ok=True)
        with open(path, "wb") as f:
            f.write(response.content)
            f.close()
        return path.resolve()

    def video_download_by_url_origin(self, url: str) -> bytes:
        """
        Download video using URL

        Parameters
        ----------
        url: str
            URL for a media

        Returns
        -------
        bytes
            Bytes for the file downloaded
        """
        response = requests.get(url, stream=True, timeout=self.request_timeout)
        response.raise_for_status()
        content_length = int(response.headers.get("Content-Length"))
        file_length = len(response.content)
        if content_length != file_length:
            raise VideoNotDownload(
                f'Broken file from url "{url}" (Content-length={content_length}, but file length={file_length})'
            )
        return response.content


class UploadVideoMixin:
    """
    Helpers for uploading video
    """

    def __init__(self, *args, **kwargs):
        super().__init

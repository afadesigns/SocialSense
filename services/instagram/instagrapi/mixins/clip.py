import json
import os
import random
import tempfile
import time
from pathlib import Path
from typing import Dict, List, Union

import moviepy.editor as mp
from PIL import Image
from instagrapi import config
from instagrapi.exceptions import ClientError, ClipConfigureError, ClipNotUpload
from instagrapi.extractors import extract_media_v1
from instagrapi.types import Location, Media, Track, Usertag
from instagrapi.utils import date_time_original


class DownloadClipMixin:
    """
    Helpers to download CLIP videos
    """

    def clip_download(self, media_pk: int, folder: Union[str, Path] = "") -> str:
        """
        Download CLIP video

        Parameters
        ----------
        media_pk: int
            PK for the album you want to download
        folder: Union[str, Path], optional
            Directory in which you want to download the album,
            default is "" and will download the files to working
            directory.

        Returns
        -------
        str
        """
        return self.video_download(media_pk, folder)

    def clip_download_by_url(
        self, url: str, filename: str = "", folder: Union[str, Path] = ""
    ) -> str:
        """


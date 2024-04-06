import contextlib
import json
import random
import time
from pathlib import Path
from typing import Dict, List, Optional, Union
from uuid import uuid4

import moviepy.editor as mp
from PIL import Image
from instagrapi import config, ClientError, IGTVConfigureError, IGTVNotUpload
from instagrapi.extractors import extract_media_v1
from instagrapi.types import Location, Media, Usertag
from instagrapi.utils import date_time_original


class DownloadIGTVMixin:
    """
    Helpers to download IGTV videos
    """

    def igtv_download(self, media_pk: int, folder: Path = Path("")) -> str:
        """
        Download IGTV video

        Parameters
        ----------
        media_pk: int
            PK for the album you want to download
        folder: Path, optional
            Directory in which you want to download the album, default is "" and will download the files to working
                directory.

        Returns
        -------
        str
        """
        return self.video_download(media_pk, folder)

    def igtv_download_by_url(
        self, url: str, filename: str = "", folder: Path = Path("")
    ) -> str:
        """
        Download IGTV video using URL

        Parameters
        ----------
        url: str
            URL to download media from
        folder: Path, optional
            Directory in which you want to download the album, default is "" and will download the files to working
                directory.

        Returns
        -------
        str
        """
        return self.video_download_by_url(url, filename, folder)


class UploadIGTVMixin:
    """
    Helpers to upload IGTV videos
    """

    def igtv_upload(
        self,
        path: Path,
        title: str,
        caption: str,
        thumbnail: Optional[Path] = None,
        usertags: List[Usertag] = [],
        location: Location = None,
        configure_timeout: int = 10,
        extra_data: Dict[str, str] = {},
        mute: bool = False,
        poster_frame_index: int = 70,
    ) -> Media:
        """
        Upload IGTV to Instagram

        Parameters
        ----------
        path: Path
            Path to IGTV file
        title: str
            Title of the video
        caption: str
            Media caption
        thumbnail: Optional[Path], optional
            Path to thumbnail for IGTV. Default value is None, and it generates a thumbnail
        usertags: List[Usertag], optional
            List of users to be tagged on this upload, default is empty list.
        location: Location, optional
            Location tag for this upload, default is none
        configure_timeout: int
            Timeout between attempt to configure media (set caption, etc), default is 10
        extra_data: Dict[str, str], optional
            Dict of extra data, if you need to add your params, like {"share_to_facebook": 1}.
        mute: bool
            Whether to upload the video as muted or not
        poster_frame_index: int
            Index of the poster frame for the video

        Returns
        -------
        Media
            An object of Media class
        """
        path = Path(path)
        if thumbnail is not None:
            thumbnail = Path(thumbnail)
        upload_id = str(int(time.time() * 1000))
        thumbnail, width, height, duration = analyze_video(path, thumbnail)
        waterfall_id = str(uuid4())
        # upload_name example: '1576102477530_0_7823256191'
        upload_name = "{upload_id}_0_{rand}".format(
            upload_id=upload_id, rand=random.randint(1000000000, 9999999999)
        )
        # by segments bb2c1d0c127384453a2122e79e4c9a85-0-6498763
        # upload_name = "{hash}-0-{rand}".format(
        #     hash="bb2c1d0c127384453a2122e79e4c9a85", rand=random.randint(1111111, 9999999)
        # )
        rupload_params = {
            "is_igtv_video": "1",
            "retry_context": '{"num_step_auto_retry":0,"num_reupload":0,"num_step_manual_retry":0}',
            "media_type": "2",
            "xsharing_user_ids": json.dumps([self.user_id]),
            "upload_id": upload_id,
            "upload_media_duration_ms": str(int(duration * 1000)),
            "upload_media_width": str(width),
            "upload_media_height": str(height),
        }
        headers = {
            "Accept-Encoding": "gzip",
            "X-Instagram

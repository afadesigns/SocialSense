import time
from pathlib import Path
from typing import Dict, List, Union
from urllib.parse import urlparse

from instagrapi.exceptions import (
    AlbumConfigureError,
    AlbumNotDownload,
    AlbumUnknownFormat,
)
from instagrapi.extractors import extract_media_v1
from instagrapi.types import Location, Media, Usertag
from instagrapi.utils import date_time_original, dumps

class DownloadAlbumMixin:
    """
    Helper class to download album
    """

    def album_download(self, media_pk: int, folder: Path = Path("")) -> List[Path]:
        """
        Download your album

        Parameters
        ----------
        media_pk: int
            PK for the album you want to download
        folder: Path, optional
            Directory in which you want to download the album, default is Path("") and will download the files to working directory.

        Returns
        -------
        List[Path]
            List of path for all the files downloaded
        """
        media = self.media_info(media_pk)
        assert media.media_type == 8, "Must been album"
        paths = []
        for resource in media.resources:
            filename = f"{media.user.username}_{resource.pk}"
            if resource.media_type == 1:
                paths.append(
                    self.photo_download_by_url(resource.thumbnail_url, filename, folder)
                )
            elif resource.media_type == 2:
                paths.append(
                    self.video_download_by_url(resource.video_url, filename, folder)
                )
            else:
                raise AlbumNotDownload(
                    'Media type "{resource.media_type}" unknown for album (resource={resource.pk})'
                )
        return paths

    def album_download_by_urls(self, urls: List[str], folder: Path = Path("")) -> List[Path]:
        """
        Download your album using specified URLs

        Parameters
        ----------
        urls: List[str]
            List of URLs to download media from
        folder: Path, optional
            Directory in which you want to download the album, default is Path("") and will download the files to working directory.

        Returns
        -------
        List[Path]
            List of path for all the files downloaded
        """
        paths = []
        for url in urls:
            file_name = urlparse(url).path.rsplit("/", 1)[1]
            if file_name.lower().endswith((".jpg", ".jpeg")):
                try:
                    paths.append(self.photo_download_by_url(url, file_name, folder))
                except AlbumUnknownFormat:
                    raise
            elif file_name.lower().endswith(".mp4"):
                paths.append(self.video_download_by_url(url, file_name, folder))
            else:
                raise AlbumUnknownFormat()
        return paths

    def album_download_origin(self, media_pk: int) -> List[bytes]:
        """
        Download your album

        Parameters
        ----------
        media_pk: int
            PK for the album you want to download

        Returns
        -------
        List[bytes]
            List of bytes for all the files downloaded
        """
        media = self.media_info(media_pk)
        assert media.media_type == 8, "Must been album"
        files = []
        for resource in media.resources:
            if resource.media_type == 1:
                files.append(self.photo_download_by_url_origin(resource.thumbnail_url))
            elif resource.media_type == 2:
                files.append(self.video_download_by_url_origin(resource.video_url))
            else:
                raise AlbumNotDownload(
                    'Media type "{resource.media_type}" unknown for album (resource={resource.pk})'
                )
        return files

class UploadAlbumMixin:
    def album_upload(
        self,
        paths: List[Path],
        caption: str,
        usertags: List[Usertag] = [],
        location: Location = None,
        configure_timeout: int = 3,
        configure_handler: Union[callable, None] = None,
        configure_exception: Union[Exception, None] = None,
        to_story=False,
        extra_data: Dict[str, str] = {},
    ) -> Media:
        """
        Upload album to feed

        Parameters
        ----------
        paths: List[Path]
            List of paths for media to upload
        caption: str
            Media caption
        usertags: List[Usertag], optional
            List of users to be tagged on this upload, default is empty list.
        location: Location, optional
            Location tag for this upload, default is None
        configure_timeout: int
            Timeout between attempt to configure media (set caption, etc), default is 3
        configure_handler
            Configure handler method, default is None


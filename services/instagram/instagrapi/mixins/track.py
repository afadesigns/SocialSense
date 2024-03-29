import shutil
from pathlib import Path
from typing import Any, Dict, Union
from urllib.parse import urlparse

import requests
from instagrapi.exceptions import ClientError, TrackNotFound
from instagrapi.extractors import extract_track
from instagrapi.types import Track
from instagrapi.utils import json_value

class TrackMixin:
    def track_download_by_url(
        self, url: str, filename: str = "", folder: Union[str, Path] = ""
    ) -> Path:
        """
        Download track by URL

        Parameters
        ----------
        url: str
            URL for a track
        filename: str, optional
            Filename for the track
        folder: str or Path, optional
            Directory in which you want to download the track,
            default is "" and will download the files to working directory

        Returns
        -------
        Path
            Path for the file downloaded
        """
        url = str(url)
        fname = urlparse(url).path.rsplit("/", 1)[1].strip()
        if not fname:
            raise ValueError("The URL must contain the path to the file (m4a or mp3).")
        ext = fname.rsplit(".", 1)[-1]
        filename = f"{filename}.{ext}" if filename else fname
        path = Path(folder).resolve() / filename
        response = requests.get(url, stream=True, timeout=self.request_timeout)
        response.raise_for_status()
        with open(path, "wb") as f:
            response.raw.decode_content = True
            shutil.copyfileobj(response.raw, f)
        return path

    def _track_request(self, data: Dict[str, Any]) -> Dict:
        """
        Make a private request to the Instagram API for track information

        Parameters
        ----------
        data: dict
            Request data

        Returns
        -------
        dict
            Response data
        """
        try:
            result = self.private_request("clips/music/", data)
        except ClientError as e:
            if not self.last_json:
                missing_keys = {
                    k: v for k, v in {"music_canonical_id", "original_sound_audio_asset_id"}.items()
                    if k not in data
                }
                raise TrackNotFound(**missing_keys) from e
            raise e
        return result

    def track_info_by_canonical_id(self, music_canonical_id: str) -> Track:
        """
        Get Track by music_canonical_id

        Parameters
        ----------
        music_canonical_id: str
            Unique identifier of the track

        Returns
        -------
        Track
            An object of Track type
        """
        if not music_canonical_id:
            raise ValueError("music_canonical_id cannot be empty.")
        data = {
            "tab_type": "clips",
            "referrer_media_id": "",
            "_uuid": self.uuid,
            "music_canonical_id": music_canonical_id,
        }
        result = self.private_request("clips/music/", data)
        track = json_value(result, "metadata", "music_info", "music_asset_info")
        return extract_track(track)

    def track_info_by_id(self, track_id: str, max_id: str = "") -> Dict:
        """
        Get Track by id

        Parameters
        ----------
        track_id: str
            Unique identifier of the track

        Returns
        -------
        dict
            Raw insta response json
        """
        if not track_id:
            raise ValueError("track_id cannot be empty.")
        data = {
            "audio_cluster_id": track_id,
            "original_sound_audio_asset_id": track_id,
        }
        if max_id:
            data["max_id"] = max_id
        return self._track_request(data)

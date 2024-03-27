import os
import tempfile
from pathlib import Path
from typing import List, Union
from urllib.parse import urlparse

import moviepy.editor as mpy
from PIL import Image

from .types import StoryBuild, StoryMention, StorySticker

class StoryBuilder:
    """
    Helpers for Story building
    """

    width: int = 720
    height: int = 1280

    def __init__(
        self,
        path: Union[str, Path],
        caption: str = "",
        mentions: List[StoryMention] = [],
        bgpath: Union[str, Path] = None,
        link: str = "",
        font: str = "Arial",
        fontsize: int = 100,
        color: str = "white",
    ):
        """
        Initialization function

        Parameters
        ----------
        path: Union[str, Path]
            Path for a file
        caption: str, optional
            Media caption, default value is ""
        mentions: List[StoryMention], optional
            List of mentions to be tagged on this upload, default is empty list
        bgpath: Union[str, Path], optional
            Path for a background image, default value is ""
        link: str, optional
            Link to be added to the story, default value is ""
        font: str, optional
            Name of font for text clip, default value is "Arial"
        fontsize: int, optional
            Size of font, default value is 100
        color: str, optional
            Color of text, default value is "white"

        Raises
        ------
        FileNotFoundError
            If the `path` argument does not exist
        ValueError
            If the `max_duration` argument is less than 0
            If the `font` argument is not a valid font
            If the `fontsize` argument is less than 0
            If the `color` argument is not a valid color
            If the `link` argument is not a valid URL
        """
        self.path = Path(path).resolve()
        if not self.path.exists():
            raise FileNotFoundError(f"File not found: {self.path}")

        self.caption = caption
        self.mentions = mentions
        self.bgpath = Path(bgpath).resolve() if bgpath else None

        if link:
            try:
                result = urlparse(link)
                self.link = result.scheme + "://" + result.netloc
            except ValueError:
                raise ValueError(f"Invalid URL: {link}")

        if font not in mpy.fonts.FONT_NAMES:
            raise ValueError(f"Invalid font: {font}")

        if fontsize < 0:
            raise ValueError(f"Invalid fontsize: {fontsize}")

        if color not in mpy.video.palettes.keys():
            raise ValueError(f"Invalid color: {color}")

    def build_main(
        self,
        clip: Union[mpy.VideoFileClip, mpy.ImageClip],
        max_duration: int = 0,
    ) -> StoryBuild:
        """
        Build clip

        Parameters
        ----------
        clip: Union[mpy.VideoFileClip, mpy.ImageClip]
            An object of either VideoFileClip or ImageClip
        max_duration: int, optional
            Duration of the clip if a video clip, default value is 0

        Returns
        -------
        StoryBuild
            An object of StoryBuild
        """
        if max_duration < 0:
            raise ValueError(f"Invalid max_duration: {max_duration}")

        clips = []
        stickers = []

        if self.bgpath and self.bgpath.exists():
            background = mpy.ImageClip(str(self.bgpath))
            clips.append(background)

        clip_left = (self.width - clip.size[0]) / 2
        clip_top = (self.height - clip.size[1]) / 2
        if clip_top > 90:
            clip_top -= 50

        media_clip = clip.set_position((clip_left, clip_top))
        clips.append(media_clip)

        mention = self.mentions[0] if self.mentions else None

        caption = self.caption
        if self.mentions:
            mention = self

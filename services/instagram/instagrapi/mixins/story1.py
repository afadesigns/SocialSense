import os
import tempfile
from pathlib import Path
from typing import List, Union
from urllib.parse import urlparse

import moviepy.editor as mpy
from PIL import Image

from .types import StoryBuild, StoryMention, StorySticker

try:
    mpy_available = True
    mpy.AudioClip
except (ImportError, AttributeError):
    mpy_available = False
    raise Exception("Please install moviepy==1.0.3 and retry")

try:
    pil_available = True
    Image.new("RGB", (1, 1))
except (ImportError, AttributeError):
    pil_available = False
    raise Exception("You don't have PIL installed. Please install PIL or Pillow>=8.1.1")


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
        bgpath: Union[str, Path]
            Path for a background image, default value is ""

        Returns
        -------
        Void
        """
        if not isinstance(path, Path):
            path = Path(path)
        if not path.exists():
            raise FileNotFoundError(f"File not found: {path}")
        self.path = path
        self.caption = caption
        self.mentions = mentions
        if not mentions:
            return
        mention = mentions[0]
        if not isinstance(mention, StoryMention):
            raise TypeError("The first element of mentions must be an instance of StoryMention")

        if bgpath:
            if not isinstance(bgpath, Path):
                bgpath = Path(bgpath)
            if not bgpath.exists():
                raise FileNotFoundError(f"File not found: {bgpath}")
            self.bgpath = bgpath
        else:
            self.bgpath = None

    def build_main(
        self,
        clip: Union[mpy.VideoClip, mpy.ImageClip],
        max_duration: int = 0,
        font: str = "Arial",
        fontsize: int = 100,
        color: str = "white",
        link: str = "",
    ) -> StoryBuild:
        """
        Build clip

        Parameters
        ----------
        clip: Union[mpy.VideoClip, mpy.ImageClip]
            An object of either VideoFileClip or ImageClip
        max_duration: int, optional
            Duration of the clip if a video clip, default value is 0
        font: str, optional
            Name of font for text clip
        fontsize: int, optional
            Size of font
        color: str, optional
            Color of text

        Returns
        -------
        StoryBuild
            An object of StoryBuild
        """
        if not mpy_available:
            raise Exception("moviepy is not installed")
        if not isinstance(clip, (mpy.VideoClip, mpy.ImageClip)):
            raise TypeError("clip must be an instance of VideoFileClip or ImageClip")
        if not isinstance(max_duration, int):
            raise TypeError("max_duration must be an integer")
        if not isinstance(font, str):
            raise TypeError("font must be a string")
        if not isinstance(fontsize, int):
            raise TypeError("fontsize must be an integer")
        if not isinstance(color, str):
            raise TypeError("color must be a string")
        if not isinstance(link, str):
            raise TypeError("link must be a string")

        clips = []
        stickers = []

        if self.bgpath:
            background = mpy.ImageClip(str(self.bgpath))
            clips.append(background)

        clip_left = (self.width - clip.size[0]) / 2
        clip_top = (self.height - clip.size[1]) / 2
        if clip_top > 90:
            clip_top -= 50
        media_clip = clip.set_

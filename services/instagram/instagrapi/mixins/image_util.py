# Copyright (c) 2017 https://github.com/ping
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

import io
import os
import re
import shutil
import tempfile
from typing import Any
from typing import BinaryIO
from typing import Callable
from typing import Dict
from typing import List
from typing import NamedTuple
from typing import Optional
from typing import Tuple
from typing import Union

import requests
from PIL import Image
from moviepy.editor import VideoFileClip
from moviepy.video.fx.all import crop
from moviepy.video.fx.all import resize
from moviepy.video.io.VideoFileClip import VideoFileClip as VideoFileClipType


class Size(NamedTuple):
    width: int
    height: int



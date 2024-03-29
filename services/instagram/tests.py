import json
import logging
import os
import os.path
import random
import unittest
from datetime import datetime, timedelta
from typing import List, Dict, Any, Union

import requests
from instagrapi import Client
from instagrapi.exceptions import DirectThreadNotFound
from instagrapi.story import StoryBuilder
from instagrapi.types import (
    Account,
    Collection,
    Comment,

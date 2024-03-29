import time
from typing import List, Dict, Union, Optional

from selenium.common.exceptions import (
    TimeoutException,
    StaleElementReferenceException,
    NoSuchElementException,
)
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.remote.webelement import WebElement

from tinderbotz.helpers.constants_helper import Socials
from tinderbotz.helpers.loadingbar import LoadingBar
from tinderbotz.helpers.match import Match
from tinderbotz.helpers.xpaths import content, modal_manager



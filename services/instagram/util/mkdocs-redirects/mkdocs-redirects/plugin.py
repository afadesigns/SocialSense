import logging
import os
import os.path
import textwrap
from urllib.parse import urlparse

from mkdocs import utils
from mkdocs.config import config_options
from mkdocs.plugins import BasePlugin

log = logging.getLogger(__name__)
log.addFilter(utils.warning_filter)

__plugin_name__ = "Redirect Plugin"



import logging
import pathlib
from urllib.parse import urlparse

import mkdocs
from mkdocs.config import config_options
from mkdocs.plugins import BasePlugin

log = logging.getLogger("mkdocs.plugin.redirects")
log.addFilter(utils.warning_filter)

__plugin_name__ = "Redirect Plugin"


def write_html(site_dir: pathlib.Path, old_path: pathlib.Path, new_path: pathlib.Path):
    """Write an HTML file in the site_dir with a meta redirect to the new page"""
    old_path_abs = old_path.resolve()
    old_dir = old_path_abs.parent
    old_dir_abs = old_dir.resolve()

    if not old_dir_abs.exists():
        log.debug("Creating directory '%s'", old_dir)
        old_dir_abs.mkdir(parents=True)

    with old_path_abs.open("w") as f:
        log.debug("Creating redirect: '%s' -> '%s'", old_path, new_path)
        f.write(
            textwrap.dedent(
                """
            <!doctype html>
            <html lang="en">
            <head>
                <meta charset="utf-8">
                <title>Redirecting...</title>
                <link rel="canonical" href="{url}">
                <meta name="robots" content="noindex">
                <script>var anchor=window.location.hash.substr(1);location.href="{url}"+(anchor?"#"+anchor:

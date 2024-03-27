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


def write_html(site_dir: str, old_path: str, new_path: str):
    """Write an HTML file in the site_dir with a meta redirect to the new page"""
    # Determine all relevant paths
    old_path_abs = os.path.join(site_dir, old_path)
    old_dir = os.path.dirname(old_path)
    old_dir_abs = os.path.dirname(old_path_abs)

    # Create parent directories if they don't exist
    if not os.path.exists(old_dir_abs):
        log.debug("Creating directory '%s'", old_dir)
        os.makedirs(old_dir_abs)

    # Write the HTML redirect file in place of the old file
    with open(old_path_abs, "w") as f:
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
                <script>var anchor=window.location.hash.substr(1);location.href="{url}"+(anchor?"#"+anchor:"")</script>
                <meta http-equiv="refresh" content="0; url={url}">
            </head>
            <body>
            Redirecting...
            </body>
            </html>
            """
            ).format(url=new_path)
        )


def get_relative_html_path(old_page: str, new_page: str, use_directory_urls: bool) -> str:
    """Return the relative path from the old html path to the new html path"""
    old_path = get_html_path(old_page, use_directory_urls)
    new_path = get_html_path(new_page, use_directory_urls)

    if use_directory_urls:
        # remove /index.html from end of path
        new_path = os.path.dirname(new_path)

    relative_path = os.path.relpath(new_path, start=os.path.dirname(old_path))

    if use_directory_urls:
        relative_path = relative_path + "/"

    return relative_path


def get_html_path(path: str, use_directory_urls: bool) -> str:
    """Return the HTML file path for a given markdown file"""
    parent, filename = os.path.split(path)
    name_orig, ext = os.path.splitext(filename)

    # Directory URLs require some different logic. This mirrors mkdocs' internal logic.
    if use_directory_urls:

        # Both `index.md` and `README.md` files are normalized to `index.html` during build
        name = "index" if name_orig.lower() in ("index", "readme") else name_orig

        # If it's name is `index`, then that means it's the "homepage" of a directory, so should get placed in that dir
        if name == "index":
            return os.path.join(parent, "index.html")

        # Otherwise, it's a file within that folder, so it should go in its own directory to resolve properly
        else:
            return os.path.join(parent, name, "index.html")

    # Just use the original name if Directory URLs aren't used
    else:
        return os.path.join(parent, (name_orig + ".html"))


class RedirectPlugin(BasePlugin):
    # Any options that this plugin supplies should go here.
    config_scheme = (
        (
            "redirect_maps",
            config_options.Type(dict, default={}),
        ),  # note the trailing comma
    )

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.redirects = {}

    # Build a list of redirects on file generation
    def on_files(self, files, config, **kwargs):
        self.redirects = config.get("redirect_maps", {})

        # SHIM! Produce a warning if the old root-level 'redirects' config is present
        if "redirects" in config:
            log.warn(
                "The root-level 'redirects:' setting is not valid and has been changed in version 1.0! "
                "The plugin-level 'redirect_map' must be used instead. See https://git.io/fjdBN"
            )

        # Validate user-provided redirect "old files"
        for page_old in self.redirects.keys():
            if not utils.is_markdown_file(page_old):
                log.warn(
                    "redirects plugin:

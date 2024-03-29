# C:/Users/Andreas/Projects/SocialSense/libraries/instagram/instagrapi/bots/volvoownersclub/repost/setup.py

"""
Setup script for the repost bot.
"""

from setuptools import find_packages, setup

# Version number
VERSION = '0.1.0'

# Project packages
PACKAGES = find_packages()

# Project dependencies
INSTALL_REQUIRES = [
    'instagrapi==1.6.2',
    'python-dotenv==0.19.0',
    'psycopg2-binary==2.9.1',
    'python-json-logger==2.0.1',
    'schedule==1.1.0',
    'requests==2.31.0',
]

# Project metadata
PROJECT_NAME = 'repost-bot'
PROJECT_AUTHOR = 'Andreas'
PROJECT_LICENSE = 'MIT License'
PROJECT_DESCRIPTION = 'A repost bot for Volvo Owners Club using instagrapi library.'
PROJECT_URL = 'https://github.com/username/repost-bot'

# Setup script
setup(
    name=PROJECT_NAME,
    version=VERSION,
    packages=PACKAGES,
    install_requires=INSTALL_REQUIRES,
    author=PROJECT_AUTHOR,
    license=PROJECT_LICENSE,
    description=PROJECT_DESCRIPTION,
    url=PROJECT_URL,
)

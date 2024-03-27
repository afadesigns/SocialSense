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

# Setup script
setup(
    name="repost-bot",
    version=VERSION,
    packages=PACKAGES,
    install_requires=INSTALL_REQUIRES,
)

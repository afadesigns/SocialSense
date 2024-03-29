# C:/Users/Andreas/Projects/SocialSense/libraries/instagram/instagrapi/bots/volvoownersclub/repost/setup.py

"""
Setup script for the repost bot.
"""

from setuptools import setup, find_packages

# Get the current version from the instagrapi package
with open("instagrapi/__init__.py") as f:
    for line in f:
        if line.startswith("__version__"):
            version = line.strip().split("=")[-1].strip().strip('"')
            break
    else:
        raise ValueError("Could not find version number in instagrapi package.")

setup(
    name="repost-bot",
    version=version,
    packages=find_packages(),
    install_requires=[
        "instagrapi>=1.6.2",  # Use a version range to allow for future updates
        "python-dotenv>=0.19.0",
        "psycopg2-binary>=2.9.1",
        "python-json-logger>=2.0.1",
        "schedule>=1.1.0",
        "requests>=2.26.0",
    ],
)


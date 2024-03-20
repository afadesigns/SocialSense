# C:/Users/Andreas/Projects/SocialSense/libraries/instagram/instagrapi/bots/volvoownersclub/repost/setup.py

from setuptools import setup, find_packages

setup(
    name="repost-bot",
    version="0.1",
    packages=find_packages(),
    install_requires=[
        "instagrapi==1.6.2",
        "python-dotenv==0.19.0",
        "psycopg2-binary==2.9.1",
        "python-json-logger==2.0.1",
        "schedule==1.1.0",
        "requests==2.31.0",
    ],
)

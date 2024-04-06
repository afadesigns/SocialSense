# C:/Users/Andreas/Projects/SocialSense/libraries/instagram/instagrapi/bots/volvoownersclub/repost/__init__.py

from .repost_bot import RepostBot as InstagramRepostBot

# Add a docstring to explain what this module does
"""
This module provides a specialized repost bot for the Volvo Owners Club Instagram account.
It uses the Instagrapi library to interact with the Instagram API.
"""

# Add a function to create and configure the bot
def create_volvo_repost_bot():
    """
    Creates and configures a Volvo Owners Club repost bot.
    """
    bot = InstagramRepostBot()
    # Add any necessary configuration or initialization here
    return bot

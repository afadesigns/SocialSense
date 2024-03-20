# C:/Users/Andreas/Projects/SocialSense/libraries/instagram/instagrapi/bots/volvoownersclub/repost/credentials.py

import os


class SecretsManager:
    @staticmethod
    def get_secret(key):
        """
        Retrieve a secret value for the given key.

        Args:
        - key: The key identifying the secret.

        Returns:
        - secret: The secret value, or None if the key is not found.
        """
        # Retrieve secret from environment variables
        return os.getenv(key)

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
        secret = os.getenv(key)

        # Check if the secret is set
        if secret is None:
            print(f"Warning: Secret key '{key}' not found in environment variables.")

        return secret

# Check if the required secrets are set
required_secrets = ['SECRET_KEY_1', 'SECRET_KEY_2']
for secret_key in required_secrets:
    secret = SecretsManager.get_secret(secret_key)
    if secret is None:
        raise Exception(f"Required secret key '{secret_key}' not set.")

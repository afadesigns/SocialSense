# File: repost_bot_async.py

import asyncio
import inspect
import json
import logging
import os
import re
import sys
from datetime import datetime, timezone
from logging.handlers import RotatingFileHandler

import asyncpg
from dotenv import load_dotenv
from pythonjsonlogger import jsonlogger

from instagrapi import Client
from instagrapi.exceptions import (
    BadPassword,
    ReloginAttemptExceeded,
    ChallengeRequired,
    PleaseWaitFewMinutes,
)

# Load environment variables from .env file
load_dotenv()

# Import SecretsManager from credentials module
from credentials import SecretsManager

# Load settings from settings.json
with open("settings.json", "r") as settings_file:
    settings = json.load(settings_file)

# File paths
LOG_FILE_PATH = "repost_bot.log"

# Database connection parameters
DB_HOST = SecretsManager.get_secret("DB_HOST")
DB_PORT = SecretsManager.get_secret("DB_PORT")
DB_NAME = SecretsManager.get_secret("DB_NAME")
DB_USER = SecretsManager.get_secret("DB_USER")
DB_PASSWORD = SecretsManager.get_secret("DB_PASSWORD")

# Logging configuration
logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)


# Custom Formatter for log messages
class CustomFormatter(jsonlogger.JsonFormatter):
    SENSITIVE_FIELDS = {
        "password",
        "username",
        "device_id",
    }  # Define sensitive field names

    def add_fields(self, log_record, record, message_dict):
        super().add_fields(log_record, record, message_dict)
        if not log_record.get("timestamp"):
            log_record["timestamp"] = datetime.now(timezone.utc).strftime(
                "%Y-%m-%d %H:%M:%S"
            )
        if not log_record.get("function"):
            frame = inspect.currentframe().f_back
            log_record["function"] = frame.f_code.co_name
            log_record["filename"] = frame.f_code.co_filename
            log_record["lineno"] = frame.f_lineno
        if log_record.get("exc_info"):
            # Add exception information to log record
            log_record["exception"] = self.format_exception(*log_record["exc_info"])
            del log_record["exc_info"]

        # Filter sensitive fields
        for field in self.SENSITIVE_FIELDS:
            if field in log_record:
                log_record[field] = "*****"  # Mask sensitive data


# Updating logHandler to use the RotatingFileHandler with log rotation
log_level = getattr(logging, settings.get("LOG_LEVEL", "INFO"))
logger.setLevel(log_level)  # Set logger level based on settings

logHandler = RotatingFileHandler(LOG_FILE_PATH, maxBytes=1_000_000, backupCount=3)
formatter = CustomFormatter()
logHandler.setFormatter(formatter)
logger.addHandler(logHandler)


class RepostBotAsync:
    """
    A class representing an Instagram Repost Bot.

    Attributes:
    - client: An instance of the Instagram API client.
    - base_interval: Initial scheduling interval in seconds.
    - max_interval: Maximum scheduling interval in seconds.
    """

    def __init__(self):
        """
        Initialize the RepostBotAsync class.
        """
        self.client = None
        self.base_interval = 3600  # Initial scheduling interval in seconds
        self.max_interval = 86400  # Maximum scheduling interval in seconds
        self.pool = None
        self.request_interval = 5  # Request interval in seconds
        self.max_retries = 3  # Maximum number of retries
        self.session = None  # Will be initialized later

    async def _connect_db(self):
        """
        Connect to the database.

        Returns:
        - pool: Database connection pool.
        """
        try:
            # Establish a connection pool to the database
            return await asyncpg.create_pool(
                database=DB_NAME,
                user=DB_USER,
                password=DB_PASSWORD,
                host=DB_HOST,
                port=DB_PORT,
            )
        except Exception as e:
            logger.error(
                {
                    "message": f"Error connecting to the database: {e}",
                    "operation": "_connect_db",
                }
            )
            raise

    async def _initialize_client(self):
        """
        Initialize the Instagram API client.

        Returns:
        - client: An instance of the Instagram API client.
        """
        # Check if the settings.json file exists
        if not os.path.exists("settings.json"):
            logger.error(
                {
                    "message": "settings.json file not found.",
                    "operation": "_initialize_client",
                }
            )
            sys.exit(1)

        # Load settings from settings.json in the correct path
        file_path = "settings.json"  # Adjust the path as needed
        try:
            with open(file_path, "r") as settings_file:
                settings = json.load(settings_file)
        except json.JSONDecodeError as e:
            logger.error(
                {
                    "message": f"Error decoding JSON in settings.json: {e}",
                    "operation": "_initialize_client",
                }
            )
            sys.exit(1)

        client = Client(settings)
        try:
            if not await client.login(
                SecretsManager.get_secret("INSTAGRAM_USERNAME"),
                SecretsManager.get_secret("INSTAGRAM_PASSWORD"),
            ):
                logger.error(
                    {"message": "Failed to log in.", "operation": "_initialize_client"}
                )
        except (BadPassword, ReloginAttemptExceeded) as e:
            logger.error(
                {"message": f"Login failed: {e}", "operation": "_initialize_client"}
            )
        except ChallengeRequired as e:
            logger.error(
                {
                    "message": f"Challenge required: {e}",
                    "operation": "_initialize_client",
                }
            )
            self._handle_challenge_required()
        except PleaseWaitFewMinutes as e:
            logger.error(
                {
                    "message": f"Please wait a few minutes: {e}",
                    "operation": "_initialize_client",
                }
            )
        except Exception as e:
            logger.error(
                {
                    "message": f"Unknown error during login: {e}",
                    "operation": "_initialize_client",
                }
            )
        return client

    async def _handle_challenge_required(self):
        """
        Handle ChallengeRequired exception by either automatically resolving the challenge or notifying the user.
        """
        try:
            # Implement your logic to automatically resolve the challenge or notify the user
            pass  # Placeholder for logic
        except Exception as e:
            logger.error(
                {
                    "message": f"Error handling ChallengeRequired: {e}",
                    "operation": "_handle_challenge_required",
                }
            )

    async def _sanitize_input(self, input_str):
        """
        Sanitize input string by removing potentially dangerous characters.

        Args:
        - input_str: The input string to be sanitized.

        Returns:
        - sanitized_str: The sanitized input string.
        """
        # Remove HTML and script tags
        sanitized_str = re.sub(r"<.*?>", "", input_str)
        # Add more sanitization steps as needed
        return sanitized_str

    async def _post_to_database(self, media_info):
        """
        Insert sanitized media information into the database.

        Args:
        - media_info: A dictionary containing media information.
        """
        try:
            async with self.pool.acquire() as conn:
                # Ensure media_info is sanitized before posting to the database
                sanitized_info = {
                    key: await self._sanitize_input(value)
                    for key, value in media_info.items()
                }
                # Execute the SQL query with sanitized values
                await conn.execute(
                    """
                    INSERT INTO Interactions.Media (media_id, media_type, user_id, url, caption, created_at)
                    VALUES ($1, $2, $3, $4, $5, $6);
                """,
                    *sanitized_info.values(),
                )
            logger.info(
                {
                    "message": "Media information inserted into the database.",
                    "operation": "_post_to_database",
                }
            )
        except Exception as e:
            logger.error(
                {
                    "message": f"Error inserting media information into the database: {e}",
                    "operation": "_post_to_database",
                }
            )
            raise  # Re-raise the exception to ensure transaction rollback

    async def _retry_on_network_error(self, func, *args, **kwargs):
        """
        Retry a function call on network errors with exponential backoff.

        Args:
        - func: The function to be retried.
        - *args: Positional arguments for the function.
        - **kwargs: Keyword arguments for the function.

        Returns:
        - result: The result of the function call.
        """
        retries = 0
        while retries < self.max_retries:
            try:
                result = await func(*args, **kwargs)
                return result
            except (ChallengeRequired, PleaseWaitFewMinutes) as e:
                logger.warning(
                    {
                        "message": f"Challenge required or please wait: {e}. Retrying...",
                        "operation": func.__name__,
                    }
                )
                retries += 1
                if isinstance(e, PleaseWaitFewMinutes):
                    await asyncio.sleep(
                        300
                    )  # Pause operation for 5 minutes before retrying
                else:
                    await asyncio.sleep(
                        5 * 2**retries
                    )  # Exponential backoff for retries
            except Exception as e:
                logger.error(
                    {
                        "message": f"Unknown error occurred: {e}",
                        "operation": func.__name__,
                        "exc_info": sys.exc_info(),
                    }
                )
                retries += 1
                await asyncio.sleep(5 * 2**retries)  # Exponential backoff for retries
        logger.error(
            {
                "message": f"Failed after {self.max_retries} retries. Aborting.",
                "operation": func.__name__,
            }
        )
        return None

    async def _download_media(self, media):
        """
        Download media from a URL.

        Args:
        - media: The media object containing the URL.

        Returns:
        - file_path: The local file path of the downloaded media.
        """
        try:
            async with self.session.get(media.url) as response:
                if response.status == 200:
                    file_name = f"media_{datetime.now().strftime('%Y%m%d%H%M%S')}.jpg"
                    file_path = os.path.join("downloads", file_name)
                    async with open(file_path, "wb") as f:
                        async for chunk in response.content.iter_any():
                            f.write(chunk)
                    logger.info(
                        {
                            "message": "Media downloaded successfully.",
                            "operation": "_download_media",
                        }
                    )
                    return file_path
                else:
                    logger.error(
                        {
                            "message": f"Failed to download media. HTTP status code: {response.status}",
                            "operation": "_download_media",
                        }
                    )
        except Exception as e:
            logger.error(
                {
                    "message": f"Unknown error downloading media: {e}",
                    "operation": "_download_media",
                }
            )
        return None

    async def _post_media(self, media, file_path, custom_caption):
        """
        Post media with a custom caption.

        Args:
        - media: The media object to be posted.
        - file_path: The local file path of the media.
        - custom_caption: A custom caption to append to the media.

        Returns:
        - success: A boolean indicating if the media was successfully posted.
        """
        try:
            if await self.client.post_photo(file_path, custom_caption):
                logger.info(
                    {
                        "message": "Media posted successfully.",
                        "operation": "_post_media",
                    }
                )
                return True
            else:
                logger.error(
                    {"message": "Failed to post media.", "operation": "_post_media"}
                )
        except ChallengeRequired as e:
            logger.error(
                {"message": f"Error posting media: {e}", "operation": "_post_media"}
            )
            if isinstance(e, ChallengeRequired):
                await self._handle_challenge_required()
        except Exception as e:
            logger.error(
                {
                    "message": f"Unknown error posting media: {e}",
                    "operation": "_post_media",
                }
            )
        return False

    async def _update_hashtag_performance(self, hashtag, success=True):
        """
        Update hashtag performance in the activity log.

        Args:
        - hashtag: The hashtag being updated.
        - success: A boolean indicating if the action was successful.

        Returns:
        - success_status: A boolean indicating if the update was successful.
        """
        try:
            async with self.pool.acquire() as conn:
                async with conn.transaction():
                    if success:
                        await conn.execute(
                            "UPDATE public.hashtags SET success_count = success_count + 1 WHERE hashtag = $1;",
                            (hashtag,),
                        )
                    await conn.execute(
                        "UPDATE public.hashtags SET total_count = total_count + 1 WHERE hashtag = $1;",
                        (hashtag,),
                    )
            return True
        except Exception as e:
            logger.error(
                {
                    "message": f"Error updating hashtag performance: {e}",
                    "operation": "_update_hashtag_performance",
                }
            )
        return False

    async def _batch_update_hashtag_performance(self, hashtag_performance):
        """
        Batch update hashtag performance in the activity log.

        Args:
        - hashtag_performance: A dictionary containing hashtag performance data.

        Returns:
        - success_status: A boolean indicating if the update was successful.
        """
        try:
            async with self.pool.acquire() as conn:
                async with conn.transaction():
                    for hashtag, success in hashtag_performance.items():
                        if success:
                            await conn.execute(
                                "UPDATE public.hashtags SET success_count = success_count + 1 WHERE hashtag = $1;",
                                (hashtag,),
                            )
                        await conn.execute(
                            "UPDATE public.hashtags SET total_count = total_count + 1 WHERE hashtag = $1;",
                            (hashtag,),
                        )
            return True
        except Exception as e:
            logger.error(
                {
                    "message": f"Error batch updating hashtag performance: {e}",
                    "operation": "_batch_update_hashtag_performance",
                }
            )
        return False

    async def _fetch_media_info(self, media_id):
        """
        Fetch media information from the Instagram API.

        Args:
        - media_id: The ID of the media to fetch information for.

        Returns:
        - media_info: A dictionary containing media information.
        """
        try:
            media_info = await self._retry_on_network_error(
                self.client.media_info,
                media_id,
            )
            return media_info
        except Exception as e:
            logger.error(
                {
                    "message": f"Error fetching media info: {e}",
                    "operation": "_fetch_media_info",
                }
            )
        return None

    async def _process_media(self, media_id, custom_caption):
        """
        Process media by downloading, posting, and updating performance metrics.

        Args:
        - media_id: The ID of the media to process.
        - custom_caption: A custom caption to append to the media.

        Returns:
        - success: A boolean indicating if the media was successfully processed.
        """
        try:
            # Fetch media information
            media_info = await self._fetch_media_info(media_id)
            if media_info:
                # Download media
                file_path = await self._download_media(media_info)
                if file_path:
                    # Post media
                    success = await self._post_media(
                        media_info, file_path, custom_caption
                    )
                    # Update hashtag performance
                    await self._update_hashtag_performance(
                        media_info["hashtag"], success
                    )
                    return success
        except Exception as e:
            logger.error(
                {
                    "message": f"Error processing media: {e}",
                    "operation": "_process_media",
                }
            )
        return False

    async def _fetch_media_to_process(self):
        """
        Fetch media IDs from the database that need to be processed.

        Returns:
        - media_ids: A list of media IDs to be processed.
        """
        try:
            async with self.pool.acquire() as conn:
                media_ids = await conn.fetch(
                    "SELECT media_id FROM repost.media WHERE processed = FALSE LIMIT 100;"
                )
                return [record["media_id"] for record in media_ids]
        except Exception as e:
            logger.error(
                {
                    "message": f"Error fetching media to process: {e}",
                    "operation": "_fetch_media_to_process",
                }
            )
        return []

    async def _process_batch(self, media_ids, custom_caption):
        """
        Process a batch of media IDs.

        Args:
        - media_ids: A list of media IDs to process.
        - custom_caption: A custom caption to append to the media.

        Returns:
        - success_status: A boolean indicating if the batch processing was successful.
        """
        try:
            # Initialize empty dictionary for hashtag performance tracking
            hashtag_performance = {}
            # Process each media ID in the batch
            for media_id in media_ids:
                success = await self._process_media(media_id, custom_caption)
                media_info = await self._fetch_media_info(media_id)
                if media_info:
                    hashtag_performance[media_info["hashtag"]] = success
            # Batch update hashtag performance
            await self._batch_update_hashtag_performance(hashtag_performance)
            return True
        except Exception as e:
            logger.error(
                {
                    "message": f"Error processing batch: {e}",
                    "operation": "_process_batch",
                }
            )
        return False

    async def run(self):
        """
        Run the repost bot asynchronously.
        """
        try:
            # Connect to the database
            self.pool = await self._connect_db()
            # Initialize the Instagram API client
            self.client = await self._initialize_client()
            while True:
                # Fetch media to process
                media_ids = await self._fetch_media_to_process()
                if media_ids:
                    # Process batch of media IDs
                    await self._process_batch(
                        media_ids, settings.get("CUSTOM_CAPTION", "")
                    )
                else:
                    logger.info({"message": "No media to process.", "operation": "run"})
                # Sleep for a specified interval
                await asyncio.sleep(self.base_interval)
                # Adjust the scheduling interval based on bot activity
                self.base_interval = min(2 * self.base_interval, self.max_interval)
        finally:
            # Close async resources properly
            await self.session.close()
            if self.pool:
                await self.pool.close()


# Run the bot asynchronously
if __name__ == "__main__":
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    )
    logger.info("Starting repost bot.")
    repost_bot = RepostBotAsync()
    asyncio.run(repost_bot.run())

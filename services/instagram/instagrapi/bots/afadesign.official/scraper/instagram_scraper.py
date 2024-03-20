import asyncio
import logging
import sys
import time
from typing import Optional, Tuple, Dict, Any, List

import aioconsole
import aiohttp
import asyncpg
from decouple import config as env_config
from tenacity import retry, stop_after_attempt, wait_random_exponential

from instagrapi import Client
from instagrapi.exceptions import TwoFactorRequired, ClientError

# Constants
SECONDS_IN_HOUR: int = 3600
MIN_CONNECTIONS: int = 1
MAX_CONNECTIONS: int = 10
DEFAULT_DELAY_MIN: int = 1
DEFAULT_DELAY_MAX: int = 3
CACHE_EXPIRATION_TIME: int = 300  # Cache expiration time in seconds (5 minutes)


class Config:
    @classmethod
    def get_database_url(cls) -> str:
        return env_config("DATABASE_URL")

    @classmethod
    def get_session_refresh_interval(cls) -> int:
        # Fetch the raw value from environment variables
        raw_value = env_config(
            "SESSION_REFRESH_INTERVAL", default=str(SECONDS_IN_HOUR // 2)
        )
        # Strip comments and whitespace
        stripped_value = raw_value.split("#")[0].strip()
        try:
            # Cast the cleaned value to int
            return int(stripped_value)
        except ValueError:
            # Log an error and raise a more informative exception if conversion fails
            raise ValueError(
                f"Invalid SESSION_REFRESH_INTERVAL value: '{raw_value}'. Must be an integer."
            )

    @classmethod
    def get_instagram_username(cls) -> str:
        return env_config("INSTAGRAM_USERNAME")

    @classmethod
    def get_instagram_password(cls) -> str:
        return env_config("INSTAGRAM_PASSWORD")


class InstagramError(Exception):
    pass


class InstagramLoginError(InstagramError):
    pass


class InstagramTwoFactorAuthError(InstagramError):
    pass


class DatabaseError(InstagramError):
    pass


class DatabaseFetchError(DatabaseError):
    pass


class DatabaseUpdateError(DatabaseError):
    pass


class DatabaseConnectionError(DatabaseError):
    pass


class DatabaseTransactionError(DatabaseError):
    pass


class DatabaseDuplicateError(DatabaseError):
    pass


class DatabaseLockError(DatabaseError):
    pass


class DatabasePostgresError(DatabaseError):
    pass


class DatabaseManager:
    def __init__(self, connection_pool: asyncpg.Pool, logger: logging.Logger) -> None:
        self.connection_pool: asyncpg.Pool = connection_pool
        self.logger: logging.Logger = logger
        self.cache: Dict[str, Tuple[float, Optional[Tuple]]] = (
            {}
        )  # Cache to store fetched followers data

    async def get_cached_followers(self, user_id: str) -> Optional[Tuple]:
        if user_id in self.cache:
            last_updated, data = self.cache[user_id]
            if time.time() - last_updated < CACHE_EXPIRATION_TIME:
                return data
            else:
                del self.cache[user_id]  # Remove stale data from cache

        try:
            async with self.connection_pool.acquire() as conn:
                row: Optional[Tuple] = await conn.fetchrow(
                    "SELECT username, full_name, profile_pic_url, is_private, is_verified, biography, follower_count, following_count, media_count, external_url, last_updated FROM followers WHERE user_id = $1",
                    user_id,
                )
                self.cache[user_id] = (time.time(), row)  # Cache fetched data
                return row
        except asyncpg.exceptions.PostgresError as e:
            raise DatabasePostgresError(f"PostgreSQL Error: {e}") from e

    async def cache_followers(
        self, user_id: str, followers: List[Dict[str, Any]]
    ) -> None:
        try:
            async with self.connection_pool.acquire() as conn:
                async with conn.transaction():
                    insert_query = """
                        INSERT INTO public.followers (
                            username, full_name, user_id, profile_pic_url,
                            is_private, is_verified, biography, follower_count, following_count, media_count, external_url
                        ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
                        ON CONFLICT (user_id) DO UPDATE SET
                            username = EXCLUDED.username,
                            full_name = EXCLUDED.full_name,
                            profile_pic_url = EXCLUDED.profile_pic_url,
                            is_private = EXCLUDED.is_private,
                            is_verified = EXCLUDED.is_verified,
                            biography = EXCLUDED.biography,
                            follower_count = EXCLUDED.follower_count,
                            following_count = EXCLUDED.following_count,
                            media_count = EXCLUDED.media_count,
                            external_url = EXCLUDED.external_url,
                            last_updated = CURRENT_TIMESTAMP;
                    """
                    values = [
                        (
                            f["username"],
                            f["full_name"],
                            f["user_id"],
                            f["profile_pic_url"],
                            f["is_private"],
                            f["is_verified"],
                            f["biography"],
                            f["follower_count"],
                            f["following_count"],
                            f["media_count"],
                            f["external_url"],
                        )
                        for f in followers
                    ]
                    await conn.executemany(insert_query, values)
                    self.cache[user_id] = (
                        time.time(),
                        None,
                    )  # Update cache after data insertion
        except asyncpg.exceptions.PostgresError as e:
            raise DatabasePostgresError(f"PostgreSQL Error: {e}") from e


class InstagramAPI:
    session_file: str = "instagram_session.json"

    def __init__(self) -> None:
        self.logger: logging.Logger = setup_logging(__name__)
        self.session_refresh_interval: int = Config.get_session_refresh_interval()
        self.connection_pool: Optional[asyncpg.Pool] = None
        self.lock = asyncio.Lock()
        self.db_manager: Optional[DatabaseManager] = None

    async def initialize_connection_pool(self) -> asyncpg.Pool:
        try:
            return await asyncpg.create_pool(
                dsn=Config.get_database_url(),
                min_size=MIN_CONNECTIONS,
                max_size=MAX_CONNECTIONS,
            )
        except asyncpg.exceptions.PostgresError as e:
            raise DatabasePostgresError(f"PostgreSQL Error: {e}") from e

    async def initialize(self) -> None:
        self.connection_pool = await self.initialize_connection_pool()
        self.db_manager = DatabaseManager(self.connection_pool, self.logger)

    @retry(
        stop=stop_after_attempt(3), wait=wait_random_exponential(multiplier=1, max=10)
    )
    async def login_user(self, client_insta: Client) -> None:
        try:
            await client_insta.login(
                Config.get_instagram_username(), Config.get_instagram_password()
            )
            self.logger.info("Login successful.")
        except TwoFactorRequired:
            raise InstagramTwoFactorAuthError("Two-factor authentication required.")
        except ClientError as e:
            raise InstagramLoginError(f"Instagram Login Error: {e}") from e
        except (asyncio.CancelledError, asyncio.TimeoutError) as e:
            self.handle_asyncio_error(e)

        await client_insta.dump_settings(self.session_file)
        self.logger.info(f"Session saved to {self.session_file}")

    async def refresh_session_periodically(self, client_insta: Client) -> None:
        while True:
            self.logger.info("Refreshing session...")
            try:
                await client_insta.reload_settings(self.session_file)
                self.logger.info("Session refreshed successfully.")
            except ClientError as e:
                raise InstagramError(f"Instagram ClientError: {e}") from e
            except (asyncio.CancelledError, asyncio.TimeoutError) as e:
                self.handle_asyncio_error(e)
            await asyncio.sleep(self.session_refresh_interval)

    async def is_session_valid(self, client_insta: Client) -> bool:
        try:
            await client_insta.user_info_by_username(
                client_insta.authenticated_user_name
            )
            return True
        except ClientError as e:
            return False

    async def refresh_session_if_needed(self, client_insta: Client) -> None:
        if not await self.is_session_valid(client_insta):
            self.logger.info("Session expired. Refreshing session...")
            await self.login_user(client_insta)
        else:
            self.logger.info("Session is still valid.")

    async def get_retry_after(self, response: aiohttp.ClientResponse) -> Optional[int]:
        retry_after: Optional[str] = response.headers.get("Retry-After")
        if retry_after:
            return int(retry_after)
        return None

    def is_cache_stale(self, last_updated: float, cache_expiration_time: int) -> bool:
        current_time: float = time.time()
        if current_time - last_updated > cache_expiration_time:
            return True
        return False

    @staticmethod
    def should_refresh_cache(user_id: str) -> bool:
        return False


def setup_logging(logger_name: str) -> logging.Logger:
    logger = logging.getLogger(logger_name)
    logger.setLevel(logging.INFO)
    handler = logging.StreamHandler()
    handler.setLevel(logging.INFO)
    formatter = logging.Formatter("%(asctime)s - %(levelname)s - %(message)s")
    handler.setFormatter(formatter)
    logger.addHandler(handler)
    return logger


async def main() -> None:
    instagram_api = InstagramAPI()
    await instagram_api.initialize()
    async with aiohttp.ClientSession() as session:
        try:
            cl: Client = Client()
            cl.delay_range = [DEFAULT_DELAY_MIN, DEFAULT_DELAY_MAX]
            await instagram_api.login_user(cl)
            target_username: str = await aioconsole.ainput(
                "Enter the username whose followers you want to fetch: "
            )
            user_id: str = cl.user_id_from_username(target_username)
            while True:
                await instagram_api.refresh_session_if_needed(cl)
                cached_data: Optional[Tuple] = (
                    await instagram_api.db_manager.get_cached_followers(user_id)
                )
                if (
                    cached_data
                    and not instagram_api.is_cache_stale(
                        cached_data[0], CACHE_EXPIRATION_TIME
                    )
                    and not instagram_api.should_refresh_cache(user_id)
                ):
                    instagram_api.logger.info("Using cached data.")
                else:
                    instagram_api.logger.info(
                        "Cached data is stale or not available. Fetching fresh data."
                    )
                    async with instagram_api.lock:
                        await instagram_api.db_manager.fetch_followers_batch(
                            cl, user_id
                        )
                await asyncio.sleep(instagram_api.session_refresh_interval)
        except KeyboardInterrupt:
            print("Received Ctrl+C. Shutting down gracefully...")
            await cleanup(instagram_api)
        except (asyncio.CancelledError, asyncio.TimeoutError) as e:
            print(f"Asyncio Error: {e}")
            await cleanup(instagram_api)
        except (
            DatabasePostgresError,
            InstagramLoginError,
            InstagramTwoFactorAuthError,
            InstagramError,
        ) as e:
            print(f"Error: {e}")
            await cleanup(instagram_api)


async def cleanup(instagram_api: InstagramAPI) -> None:
    await instagram_api.db_manager.connection_pool.close()
    sys.exit(0)


if __name__ == "__main__":
    loop = asyncio.get_event_loop()
    instagram_api = InstagramAPI()
    loop.run_until_complete(main())

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

import instagrapi
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
        raw_value = env_config(
            "SESSION_REFRESH_INTERVAL", default=str(SECONDS_IN_HOUR // 2)
        )
        stripped_value = raw_value.split("#")[0].strip()
        try:
            return int(stripped_value)
        except ValueError:
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
        self.cache: Dict[str, Tuple[float, Optional[Tuple]]] = {}

    async def get_cached_followers(self, user_id: str) -> Optional[Tuple]:
        if user_id in self.cache:
            last_updated, data = self.cache[user_id]
            if time.time() - last_updated < CACHE_EXPIRATION_TIME:
                return data
            else:
                del self.cache[user_id]

        async with self.connection_pool.acquire() as conn:
            row: Optional[Tuple] = await conn.fetchrow(
                "SELECT username, full_name, profile_pic_url, is_private, is_verified, biography, follower_count, following_count, media_count, external_url, last_updated FROM followers WHERE user_id = $1",
                user_id,
            )
            self.cache[user_id] = (time.time(), row)
            return row

    async def cache_followers(
        self, user_id: str, followers: List[Dict[str, Any]]
    ) -> None:
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

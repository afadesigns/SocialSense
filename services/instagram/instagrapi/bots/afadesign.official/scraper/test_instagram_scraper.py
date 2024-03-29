# test_instagram_scraper.py
import asyncio
import logging

import aiohttp
import aioredis
import pytest
from unittest.mock import patch

from instagrapi import Client


@pytest.fixture
async def redis():
    redis_url = "redis://localhost:6379"
    redis = await aioredis.create_redis_pool(redis_url)
    yield redis
    redis.close()
    await redis.wait_closed()


class UserCacheManager:
    def __init__(self, redis):
        self.redis = redis

    async def cache_user_data(self, user_id, user_data):
        key = f"user:{user_id}"
        await self.redis.set(key, asyncio.serialize(user_data))

    async def get_cached_user_data(self, user_id):
        key = f"user:{user_id}"
        user_data = await self.redis.get(key)
        return asyncio.deserialize(user_data) if user_data else None


@pytest.fixture
async def user_cache_manager(redis):
    yield UserCacheManager(redis)


class FollowerCacheManager:
    def __init__(self, redis):
        self.redis = redis

    async def cache_followers(self, user_id, followers):
        key = f"followers:{user_id}"
        await self.redis.set(key, asyncio.serialize(followers))

    async def get_cached_followers(self, user_id):
        key = f"followers:{user_id}"
        followers = await self.redis.get(key)
        return asyncio.deserialize(followers) if followers else None


@pytest.fixture
async def follower_cache_manager(redis):
    yield FollowerCacheManager(redis)


class ConfigManager:
    def __init__(self):
        self.config = {"base_url": "https://www.instagram.com"}


class InstagramAPI:
    def __init__(self):
        self.cl = Client()
        self.cl.session = aiohttp.ClientSession()

    async def login_user(self, cl, username, password):
        await cl.login(username, password)

    async def refresh_session_if_needed(self, cl):
        if not cl.is_logged_in:
            await self.login_user(cl, "test_username", "test_password")


@pytest.fixture
async def instagram_api(user_cache_manager, follower_cache_manager):
    api = InstagramAPI()
    await api.refresh_session_if_needed(api.cl)
    yield api


class CacheInvalidationManager:
    async def start_cache_invalidation_listener(self, redis):
        async for msg in redis.monitor():
            if msg["type"] == "hset":
                channel, key = msg["args"][0].decode(), msg["args"][2].decode()
                if channel == "cache_invalidation_channel":
                    await redis.delete(f"user:{key}")
                    await redis.delete(f"followers:{key}")


@pytest.fixture
async def cache_invalidation_manager(redis):
    yield CacheInvalidationManager()


class HTTPClient:
    async def fetch_data(self, url):
        async with aiohttp.ClientSession() as session:
            async with session.get(url) as response:
                return await response.json()

    @patch("aiohttp.ClientSession.request")
    def handle_response(self, mock_request, *args, **kwargs):
        mock_request.return_value.__aenter__.return_value.json.return_value = {
            "key": "value"
        }


@pytest.fixture
async def http_client():
    yield HTTPClient()


@pytest.mark.asyncio
async def test_login_user(instagram_api):
    await instagram_api.login_user(instagram_api.cl, "test_username", "test_password")
    assert instagram_api.cl.is_logged_in


@pytest.mark.asyncio
async def test_refresh_session_if_needed(instagram_api):
    await instagram_api.refresh_session_if_needed(instagram_api.cl)
    assert instagram_api.cl.is_logged_in


@pytest.mark.asyncio
async def test_cache_user_data(user_cache_manager):
    user_id = "test_user_id"
    user_data = {"name": "Test User", "scraper": 1000}
    await user_cache_manager.cache_user_data(user_id, user_data)
    cached_data = await user_cache_manager.get_cached_user_data(user_id)
    assert cached_data == user_data


@pytest.mark.asyncio
async def test_cache_followers(follower_cache_manager):
    user_id = "test_user_id"
    followers = [{"username": "follower1"}, {"username": "follower2"}]
    await follower_cache_manager.cache_followers(user_id, followers)
    cached_followers = await follower_cache_manager.get_cached_followers(user_id)
    assert cached_followers == followers


@pytest.mark.asyncio
async def test_start_cache_invalidation_listener(
    cache_invalidation_manager, redis, caplog
):
    caplog.set_level(logging.INFO)
    await cache_invalidation_manager.start_cache_invalidation_listener(redis)
    await

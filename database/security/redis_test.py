import redis

# Connect to Redis without a password
redis_db = redis.StrictRedis(host="localhost", port=6379, db=0)

# Test Redis connection by setting a key
redis_db.set("test_key", "test_value")

# Retrieve and print the value of the test key
print(redis_db.get("test_key").decode("utf-8"))

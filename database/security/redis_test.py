import redis

# Connect to Redis with a password (if any)
try:
    redis_db = redis.StrictRedis(host="localhost", port=6379, db=0, password="my_password")
except redis.exceptions.ConnectionError as err:
    print(f"Could not connect to Redis: {err}")
    exit(1)

# Define a function to set a key-value pair in Redis
def set_key_value(key, value):
    try:
        redis_db.set(key, value)
    except redis.exceptions.DataError as err:
        print(f"Invalid value for key '{key}': {err}")
        exit(1)

# Define a function to get the value of a key from Redis
def get_key_value(key):
    value = redis_db.get(key)
    if value is None:
        print(f"Key '{key}' not found")
        return None
    else:
        return value.decode("utf-8")

# Test Redis connection by setting a key
set_key_value("test_key", "test_value")

# Retrieve and print the value of the test key
print(get_key_value("test_key"))


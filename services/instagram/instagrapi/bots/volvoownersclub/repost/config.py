import json
from typing import Any

def load_config(file_path: str = "settings.json") -> dict[str, Any] | None:
    try:
        with open(file_path, "r") as f:
            return json.load(f)  # Parse the contents as JSON
    except FileNotFoundError:
        print(f"Error: File '{file_path}' not found.")
    except Exception as e:
        print(f"Error loading config from '{file_path}': {e}")
    return None

# Usage example
config = load_config()
if config is not None:
    DEFAULT_HASHTAGS = config.get("DEFAULT_HASHTAGS", [])
    CUSTOM_CAPTION = config.get("CUSTOM_CAPTION", "")
    ACTIVITY_LOG = config.get("ACTIVITY_LOG", "")
    LOG_LEVEL = config.get("LOG_LEVEL", "INFO")  # Get log level from config or default to INFO

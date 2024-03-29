import hashlib
import json
import random
import string
import time
import requests
from pathlib import Path
from PIL import Image
from imageio import imread, imwrite
from shutil import copyfile
from contextlib import suppress

class StorageHelper:
    @staticmethod
    def id_generator(size: int = 6, chars: str = string.ascii_uppercase + string.digits) -> str:
        """Generate a random ID with the given size and characters.

        Returns:
            str: The generated ID.
        """
        return "".join(random.choice(chars) for _ in range(size))

    @staticmethod
    def store_image_as(url: str, directory: str, amount_of_attempts: int = 1) -> str:
        """Store an image from the given URL in the specified directory and return its hash value.

        Args:
            url (str): The URL of the image.
            directory (str): The directory where the image should be stored.
            amount_of_attempts (int, optional): The number of attempts to download the image. Defaults to 1.

        Returns:
            str: The hash value of the stored image.
        """
        directory = Path(directory)
        directory.mkdir(parents=True, exist_ok=True)

        headers = {
            "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.64 Safari/537.11",
            "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
            "Accept-Charset": "ISO-8859-1,utf-8;q=0.7,*;q=0.3",
            "Accept-Encoding": "none",
            "Accept-Language": "en-US,en;q=0.8",
            "Connection": "keep-alive",
        }

        for attempt in range(amount_of_attempts):
            try:
                response = requests.get(url, headers=headers, timeout=10)
                response.raise_for_status()
                break
            except requests.exceptions.RequestException as e:
                if attempt < 20 - 1:
                    sleep_time = (attempt + 1) * 30
                    print(f"Attempt number {attempt + 1}: sleeping for {sleep_time} seconds...")
                    time.sleep(sleep_time)
                else:
                    error = (
                        f"Amount of attempts exceeded in storage_helper\n"
                        f"attempting to get url: {url}\n"
                        f"resulted in error: {e}"
                    )
                    print(error)
                    return None

        temp_name = "temporary"
        image_path = directory / f"{temp_name}.jpg"

        if ".jpg" in url or ".jpeg" in url:
            with open(image_path, "wb") as f:
                f.write(response.content)
        elif ".webp" in url:
            with open(f"{temp_name}.webp", "wb") as f:
                f.write(response.content)

            im = Image.open(f"{temp_name}.webp").convert("RGB")
            imwrite(str(image_path), im)

            with suppress(FileNotFoundError):
                os.remove(f"{temp_name}.webp")
        else:
            print("URL of image cannot be saved!")
            print(f"URL DOES NOT CONTAIN .JPG OR .WEBP EXTENSION: {url}")
            return None

        image = imread(str(image_path))
        hashvalue = hashlib.md5(image.tobytes()).hexdigest()

        stored_image_path = directory / f"{hashvalue}.jpg"
        copyfile(image_path, stored_image_path)

        print(f"Image saved as {stored_image_path}")

        return hashvalue

    @staticmethod
    def store_match(match, directory: str, filename: str):
        """Store a match object in a JSON file in the specified directory.

        Args:
            match: The match object to be stored.
            directory (str): The directory where the JSON file should be stored.
            filename (str): The name of the JSON file.
        """
        directory = Path(directory)
        filepath = directory / f"{filename}.json"

        try:
            with filepath.open("r", encoding="utf-8") as fp:
                data = json.load(fp)
        except IOError:
            print("Could not read file, starting from scratch")
            data = {}

        data[match.get_id()] = match.get_dictionary()

        with filepath.open("w+", encoding="utf-8") as file:
            json.dump(data, file)


pip install requests

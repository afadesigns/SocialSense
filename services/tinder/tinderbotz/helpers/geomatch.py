import os
import cv2
import numpy as np
import requests
from deepface import DeepFace
from typing import List, Dict, Any
from tinderbotz.helpers.storage_helper import StorageHelper

class Geomatch:
    def __init__(
        self,
        name: str,
        age: int,
        work: str,
        study: str,
        home: str,
        gender: str,
        bio: str,
        lifestyle: str,
        basics: str,
        anthem: str,
        passions: List[str] = None,
        image_urls: List[str] = None,
        instagram: str = None,
    ):
        self.name = name
        self.age = age
        self.work = work
        self.study = study
        self.home = home
        self.gender = gender
        self.passions = passions or []
        self.bio = bio
        self.lifestyle = lifestyle
        self.basics = basics
        self.anthem = anthem
        self.image_urls = image_urls or []
        self.instagram = instagram

        # create a unique id for this person
        self.id = f"{name}{age}{StorageHelper.id_generator(size=4)}"
        self.images_by_hashes = []

        # Initialize dictionary with instance attributes
        self.data: Dict[str, Any] = {
            "name": self.name,
            "age": self.age,
            "work": self.work,
            "study": self.study,
            "home": self.home,
            "gender": self.gender,
            "passions": self.passions,
            "bio": self.bio,
            "lifestyle": self.lifestyle,
            "basics": self.basics,
            "anthem": self.anthem,
            "image_urls": self.image_urls,
            "images_by_hashes": self.images_by_hashes,
            "instagram": self.instagram,
        }

    def get_images_ai_data(self) -> List[Dict[str, Any]]:
        images_ai_data = []
        for image_url in self.image_urls:
            try:
                resp = requests.get(image_url, stream=True).raw
                image = np.asarray(bytearray(resp.read()), dtype="uint8")
                image = cv2.imdecode(image, cv2.IMREAD_COLOR)
                if image is not None:
                    ai_data = DeepFace.analyze(image, enforce_detection=False)
                    images_ai_data.append(ai_data)
            except Exception as e:
                print(f"Error processing image {image_url}: {e}")
        return images_ai_data

if __name__ == "__main__":
    # Example usage
    geomatch = Geomatch(
        name="John Doe",
        age=30,
        work="Software Engineer",
        study="Computer Science",
        home="New York",
        gender="Male",
        bio="I'm a friendly and outgoing person.",
        lifestyle="Active and adventurous.",
        basics="I love traveling and trying new foods.",
        anthem="We Will Rock You",
        passions=["music", "movies", "technology"],
        image_urls=["https://example.com/image1.jpg", "https://example.com/image2.jpg"],
        instagram="johndoe",
    )

    print(geomatch.data)
    print(geomatch.get_images_ai_data())

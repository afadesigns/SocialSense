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
                    image_ai_data = self._get_image_ai_data(image)
                    if image_ai_data is not None:
                        images_ai_data.append(image_ai_data)
            except Exception as e:
                print(f"Error processing image {image_url}: {e}")
        return images_ai_data

    def _get_image_ai_data(self, image: np.ndarray) -> Dict[str, Any]:
        try:
            return DeepFace.analyze(image, enforce_detection=False)
        except Exception as e:
            print(f"Error analyzing image with DeepFace: {e}")
            return None

    def get_dictionary(self) -> Dict[str, Any]:
        return self.data

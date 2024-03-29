"""
Created by Frederikme (TeetiFM)
"""

import random
import time
from typing import List, Dict

import tinderbotz.session

def print_geomatch_data(geomatch: tinderbotz.session.Geomatch) -> None:
    """Prints geomatch data with better formatting."""
    data = geomatch.get_dictionary()
    print(f"Name: {data['name']}")
    print(f"Image URLs: {', '.join(data['image_urls'])}")
    print(f"Bio: {data['bio']}")

def login(session: tinderbotz.session.Session, email: str, password: str, use_facebook: bool = False) -> None:
    """Logs in using email and password or Facebook login."""
    if use_facebook:
        session.login_using_facebook(email, password)
    else:
        session.login_using_google(email, password)
    # Add delay to mimic human behavior
    time.sleep(random.uniform(2, 5))

if __name__ == "__main__":
    # Creates instance of session
    session = tinderbotz.session.Session()

    # Set a custom location
    session.set_custom_location(latitude=50.879829, longitude=4.700540)

    # Replace this with your own email and password!
    email = "example@gmail.com"
    password = "password123"

    # Login using your Google account with a verified email! Alternatively, you can use Facebook login
    login(session, email, password)

    while True:
        try:
            # When scraping we want ALL images and not just the first few.
            # If you want to scrape a lot quicker, I recommend putting quickload on True
            # But note that you'd only get 1-3 image urls instead of them all.
            geomatch = session.get_geomatch(quickload=False)

            # Check if crucial data is not empty (This will rarely be the case tho, but we want a 'clean' dataset
            if geomatch.get_name() and geomatch.get_image_urls():

                # Let's store the data of the geomatch locally (this includes all images!)
                session.store_local(geomatch)

                # Display the saved data on your console
                print_geomatch_data(geomatch)

                # Account is scraped, now dislike and go next (since dislikes are infinite)
                # NOTE: if no amount is passed, it will dislike once -> same as => dislike(amount=1)
                # NOTE: if you have TinderPlus, -Gold or -Platinum you could also use session.like()
                session.dislike()

            else:


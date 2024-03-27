import os
import time

from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait
from tinderbotz.helpers.xpaths import content, modal_manager

class ProfileHelper:
    """
    Helper class to handle Tinder profile related operations.
    """

    delay: int = 5
    HOME_URL: str = "https://www.tinder.com/app/profile"

    def __init__(self, browser):
        """
        Initializes the ProfileHelper class with a web browser instance.

        :param browser: Web browser instance
        """
        self.browser = browser

        # open profile
        try:
            xpath = '//*[@href="/app/profile"]'
            WebDriverWait(self.browser, self.delay).until(
                EC.visibility_of_element_located((By.XPATH, xpath))
            )
            self.browser.find_element_by_xpath(xpath).click()
        except Exception as e:
            print(f"Error while opening profile: {e}")

        self._edit_info()

    def _edit_info(self):
        """
        Clicks on the "Edit Info" button.
        """
        xpath = '//a[@href="/app/profile/edit"]'

        try:
            WebDriverWait(self.browser, self.delay).until(
                EC.visibility_of_element_located((By.XPATH, xpath))
            )
            self.browser.find_element_by_xpath(xpath).click()
        except Exception as e:
            print(f"Error while clicking on Edit Info: {e}")

    def _save(self):
        """
        Clicks on the "Save" button.
        """
        xpath = f"{content}/div/div[1]/div/main/div[1]/div/div/div/div/div[1]/a"

        try:
            WebDriverWait(self.browser, self.delay).until(
                EC.visibility_of_element_located((By.XPATH, xpath))
            )
            self.browser.find_element_by_xpath(xpath).click()
            time.sleep(1)
        except Exception as e:
            print(f"Error while clicking on Save: {e}")

    def add_photo(self, filepath: str):
        """
        Adds a photo to the profile.

        :param filepath: Absolute filepath of the photo to be added
        """
        filepath = os.path.abspath(filepath)

        # "add media" button
        xpath = (
            f"{content}/div/div[1]/div/main/div[1]/div/div/div/div/div[2]/span/button"
        )
        try:
            WebDriverWait(self.browser, self.delay).until(
                EC.visibility_of_element_located((By.XPATH, xpath))
            )
            btn = self.browser.find_element_by_xpath(xpath)
            self.browser.execute_script("arguments[0].scrollIntoView();", btn)
            btn.click()
        except Exception as e:
            print(f"Error while clicking on add media: {e}")

        xpath_input = f"{modal_manager}/div/div/div[1]/div[2]/div[2]/div/div/input"
        try:
            WebDriverWait(self.browser, self.delay).until(
                EC.visibility_of_element_located((By.XPATH, xpath_input))
            )
            self.browser.find_element_by_xpath(xpath_input).send_keys(filepath)
        except Exception as e:
            print(f"Error while entering filepath: {e}")

        xpath_choose = f"{modal_manager}/div/div/div[1]/div[1]/button[2]"
        try:
            WebDriverWait(self.browser, self.delay).until(
                EC.visibility_of_element_located((By.XPATH, xpath_choose))
            )
            self.browser.find_element_by_xpath(xpath_choose).click()
        except Exception as e:
            print(f"Error while clicking on Choose: {e}")

        self._save()

    def set_bio(self, bio: str):
        """
        Sets the bio of the profile.

        :param bio: Bio to be set
        """
        xpath = f"{content}/div/div[1]/div/main/div[1]/div/div/div/div/div[2]/div[2]/div/textarea"

        try:
            WebDriverWait(self.browser, self.delay).until(
                EC.visibility_of_element_located((By.XPATH, xpath))


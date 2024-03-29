import re
import time
from selenium.common.exceptions import (
    ElementClickInterceptedException,
    NoSuchElementException,
    StaleElementReferenceException,
    TimeoutException,
)
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait


class GeomatchHelper:
    delay = 5
    HOME_URL = "https://www.tinder.com/app/recs"

    def __init__(self, browser):
        self.browser = browser
        self.content_xpath = f'{content}/div/div[1]/div/main/div[1]/div/div'

        if "/app/recs" not in self.browser.current_url:
            self._get_home_page()

    def like(self) -> bool:
        try:
            action = ActionChains(self.browser)
            action.send_keys(Keys.ARROW_RIGHT).perform()
            return True
        except (TimeoutException, ElementClickInterceptedException):
            self._get_home_page()
        return False

    def dislike(self):
        try:
            action = ActionChains(self.browser)
            action.send_keys(Keys.ARROW_LEFT).perform()
        except (TimeoutException, ElementClickInterceptedException):
            self._get_home_page()

    def superlike(self):
        try:
            action = ActionChains(self.browser)
            action.send_keys(Keys.ARROW_UP).perform()
            time.sleep(1)
        except (TimeoutException, ElementClickInterceptedException):
            self._get_home_page()

    def _open_profile(self, second_try=False):
        if self._is_profile_opened():
            return
        try:
            action = ActionChains(self.browser)
            action.send_keys(Keys.ARROW_UP).perform()
        except (ElementClickInterceptedException, TimeoutException):
            if not second_try:
                print("Trying again to locate the profile info button in a few seconds")
                time.sleep(2)
                self._open_profile(second_try=True)
            else:
                self.browser.refresh()
        except:
            self.browser.get(self.HOME_URL)
            if not second_try:
                self._open_profile(second_try=True)

    def get_name(self):
        if not self._is_profile_opened():
            self._open_profile()

        try:
            xpath = f"{self.content_xpath}/div[1]/div/div[2]/div[1]/div/div[1]/div/h1"
            element = WebDriverWait(self.browser, self.delay).until(
                EC.presence_of_element_located((By.XPATH, xpath))
            )
            return element.text
        except Exception as e:
            pass

    def get_age(self):
        if not self._is_profile_opened():
            self._open_profile()

        try:
            xpath = f"{self.content_xpath}/div[1]/div/div[2]/div[1]/div/div[1]/span"
            element = WebDriverWait(self.browser, self.delay).until(
                EC.presence_of_element_located((By.XPATH, xpath))
            )
            age = element.text
            try:
                age = int(age)
            except ValueError:
                age = None
            return age
        except:
            pass

    def is_verified(self):
        if not self._is_profile_opened():
            self._open_profile()

        try:
            xpath = f"{self.content_xpath}/div[1]/div/div[2]/div[1]/div/div[1]/div[2]"
            return self.browser.find_element(By.XPATH, xpath)
        except NoSuchElementException:
            return False

    def get_row_data(self):
        if not self._is_profile_opened():
            self._open_profile()

        rowdata = {}

        xpath = f"{self.content_xpath}/div[1]/div/div[2]/div[2]/div"
        rows = self.browser.find_elements(By.XPATH, xpath)

        for row in rows:
            svg = row.find_element(By.XPATH, ".//*[starts-with(@d, 'M')]").get_attribute("d")
            value = row.find_element(By.XPATH, ".//div[2]").text

            if svg == self._WORK_SVG_PATH:
                rowdata["work"] = value
            if svg == self._STUDYING_SVG_PATH:
                rowdata["study"] = value
            if svg == self._HOME_SVG_PATH:
                rowdata["home"] = value.split(" ")[-1]
            if svg == self._GENDER_SVG_PATH:
                rowdata["gender"] = value
            if svg == self._LOCATION_SVG_PATH or svg == self._LOCATION_SVG_PATH_2:
                distance = value.split(" ")[0]
                try:
                    distance = int(distance)
                except TypeError:
                    distance = None
                except ValueError:
                    distance = None

                rowdata["distance"] = distance

        return rowdata

    def get_bio_and_passions(self):
        if not self._is_profile_opened():
            self._open_profile()

        bio = None
        looking_for = None

        infoItems = {"passions": [], "lifestyle": [], "basics": []}


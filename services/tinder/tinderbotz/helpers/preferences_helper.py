import time
from selenium.common.exceptions import TimeoutException
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait
from tinderbotz.helpers.constants_helper import Sexuality


class PreferencesHelper:
    """
    A helper class to set preferences for a Tinder profile.
    """

    delay: int = 5

    HOME_URL: str = "https://www.tinder.com/app/profile"

    def __init__(self, browser):
        """
        Initializes the PreferencesHelper object with the given web browser.

        :param browser: The web browser to use for interacting with the Tinder website.
        """
        self.browser = browser

        # Open profile
        try:
            xpath = '//*[@href="/app/profile"]'
            WebDriverWait(self.browser, self.delay).until(
                EC.presence_of_element_located((By.XPATH, xpath))
            )
            self.browser.find_element(By.XPATH, xpath).click()
        except TimeoutException:
            pass

    def set_distance_range(self, km: int) -> None:
        """
        Sets the distance range preference for the Tinder profile.

        :param km: The maximum distance in kilometers.
        """
        # Correct out of bounds values
        if km > 160:
            final_percentage = 100
        elif km < 2:
            final_percentage = 0
        else:
            final_percentage = (km / 160) * 100

        possible_xpaths = [
            '//*[@aria-label="Maximum distance in kilometres"]',
            '//*[@aria-label="Maximum distance in kilometers"]',
            '//*[@aria-label="Maximum distance in miles"]',
        ]

        for xpath in possible_xpaths:
            try:
                WebDriverWait(self.browser, self.delay).until(
                    EC.presence_of_element_located((By.XPATH, xpath))
                )
                link = self.browser.find_element(By.XPATH, xpath)
                break
            except TimeoutException:
                continue

        print("\nSlider of distance will be adjusted...")
        current_percentage = float(
            link.get_attribute("style").split(" ")[1].split("%")[0]
        )
        print("from {}% = {}km".format(current_percentage, current_percentage * 1.6))
        print("to {}% = {}km".format(final_percentage, final_percentage * 1.6))
        print("with a fault margin of 1%\n")

        # Start adjusting the distance slider
        while abs(final_percentage - current_percentage) > 1:
            ac = ActionChains(self.browser)
            if current_percentage < final_percentage:
                ac.click_and_hold(link).move_by_offset(3, 0).release(link).perform()
            elif current_percentage > final_percentage:
                ac.click_and_hold(link).move_by_offset(-3, 0).release(link).perform()
            # Update current percentage
            current_percentage = float(
                link.get_attribute("style").split(" ")[1].split("%")[0]
            )

        print(
            "Ended slider with {}% = {}km\n\n".format(
                current_percentage, current_percentage * 1.6
            )
        )

    def set_age_range(self, min: int, max: int) -> None:
        """
        Sets the age range preference for the Tinder profile.

        :param min: The minimum age.
        :param max: The maximum age.
        """
        # Locate elements
        xpath = '//*[@aria-label="Minimum age"]'
        WebDriverWait(self.browser, self.delay).until(
            EC.presence_of_element_located((By.XPATH, xpath))
        )
        btn_minage = self.browser.find_element(By.XPATH, xpath)

        xpath = '//*[@aria-label="Maximum age"]'
        WebDriverWait(self.browser, self.delay).until(
            EC.presence_of_element_located((By.XPATH, xpath))
        )
        btn_maxage = self.browser.find_element(By.XPATH, xpath)

        min_age_tinder = int(btn_maxage.get_attribute("aria-valuemin"))
        max_age_tinder = int(btn_maxage.get_attribute("aria-valuemax"))

        # Correct out of bounds values
        if min < min_age_tinder:
            min = min_age_tinder

        if max > max_age_tinder:
            max = max_age_tinder

        while max - min < 5:
            max += 1
            min -= 1

            if min < min_age_tinder:
                min = min_age_tinder
            if max > max_age_tinder:
                max = max_age_tinder

        range_ages_tinder = max_age_tinder - min_age_tinder
        percentage_

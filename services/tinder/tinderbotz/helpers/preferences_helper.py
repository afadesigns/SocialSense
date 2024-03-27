import time
from selenium.common.exceptions import TimeoutException, NoSuchElementException
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait

class PreferencesHelper:
    delay = 5

    HOME_URL = "https://www.tinder.com/app/profile"

    def __init__(self, browser):
        self.browser = browser

        # Open profile
        try:
            xpath = '//*[@href="/app/profile"]'
            self.wait_for_element_to_be_clickable((By.XPATH, xpath)).click()
        except NoSuchElementException:
            pass

    def set_distance_range(self, km: int) -> None:
        """Set the distance range preference.

        Args:
            km (int): The maximum distance in kilometers.
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
                link = self.wait_for_element_to_be_clickable((By.XPATH, xpath))
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
        time.sleep(5)

    def set_age_range(self, min: int, max: int) -> None:
        """Set the age range preference.

        Args:
            min (int): The minimum age.
            max (int): The maximum age.
        """
        # Locate elements
        xpath = '//*[@aria-label="Minimum age"]'
        btn_minage = self.wait_for_element_to_be_clickable((By.XPATH, xpath))

        xpath = '//*[@aria-label="Maximum age"]'
        btn_maxage = self.wait_for_element_to_be_clickable((By.XPATH, xpath))

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
        percentage_per_year = 100 / range_ages_tinder

        to_percentage_min = (min - min_age_tinder) * percentage_per_year
        to_percentage_max = (max - min_age_tinder) * percentage_per_year

        current_percentage_min = float(
            btn_minage.get_attribute("style").split(" ")[1].split("%")[0]
        )
        current_percentage_max = float(
            btn_maxage.get_attribute("style").split(" ")[1].split("%")[0]
        )

        print("\nSlider of ages will be adjusted...")
        print("Minimum age will go ...")
        print(
            "from {}% = {} years old".format(
                current_percentage_min,
                (current_percentage_min / percentage_per_year) + min_age_tinder,
            )
        )
        print("to {}% = {} years old".format(to_

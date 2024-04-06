import time
from selenium.common.exceptions import (
    TimeoutException,
    ElementClickInterceptedException,
    StaleElementReferenceException,
    NoSuchElementException,
    WebDriverException,
)
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait


class LoginHelper:
    delay: int = 7

    def __init__(self, browser):
        self.browser = browser
        self._accept_cookies()

    def _click_login_button(self):
        try:
            xpath = "/div/div[1]/div/main/div[1]/div/div/div/div/header/div/div[2]/div[2]/a"
            button = WebDriverWait(self.browser, self.delay).until(
                EC.element_to_be_clickable((By.XPATH, xpath))
            )
            button.click()

        except TimeoutException:
            self._exit_by_time_out()

        except WebDriverException as e:
            print(f"An error occurred while clicking the login button: {e}")

    def login_by_google(self, email: str, password: str):
        self._click_login_button()

        try:
            xpath = '//*[@aria-label="Log in with Google"]'
            WebDriverWait(self.browser, self.delay).until(
                EC.element_to_be_clickable((By.XPATH, xpath))
            )
            self.browser.find_element(By.XPATH, xpath).click()

        except TimeoutException:
            self._exit_by_time_out()

        if not self._change_focus_to_pop_up():
            print("FAILED TO CHANGE FOCUS TO POPUP")
            print("Let's try again...")
            return self.login_by_google(email, password)

        try:
            xpath = "//input[@type='email']"
            WebDriverWait(self.browser, self.delay).until(
                EC.visibility_of_element_located((By.XPATH, xpath))
            )

            emailfield = self.browser.find_element(By.XPATH, xpath)
            emailfield.send_keys(email)
            emailfield.send_keys(Keys.ENTER)
            time.sleep(3)
        except TimeoutException:
            self._exit_by_time_out()

        try:
            xpath = '//*[@type="password"]'
            passwordfield = WebDriverWait(self.browser, self.delay).until(
                EC.visibility_of_element_located((By.XPATH, xpath))
            )
            passwordfield.send_keys(password)
            passwordfield.send_keys(Keys.ENTER)

        except TimeoutException:
            self._exit_by_time_out()

        self._change_focus_to_main_window()
        self._handle_popups()

    # ... (other methods follow)

    def _change_focus_to_pop_up(self):
        max_tries = 50
        current_tries = 0

        main_window = None
        while not main_window and current_tries < max_tries:
            current_tries += 1
            main_window = self.browser.current_window_handle

        current_tries = 0
        popup_window = None
        while not popup_window:
            current_tries += 1
            time.sleep(0.30)
            if current_tries >= max_tries:
                return False

            for handle in self.browser.window_handles:
                if handle != main_window:
                    popup_window = handle
                    break

        self.browser.switch_to.window(popup_window)
        return True

    # ... (other methods follow)

import time
from typing import Any
from selenium.common.exceptions import (
    TimeoutException,
    ElementClickInterceptedException,
    StaleElementReferenceException,
    NoSuchElementException,
)
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait


class LoginHelper:
    @property
    def delay(self) -> int:
        return 7

    def __init__(self, browser):
        self.browser = browser
        self._accept_cookies()

    def _click_login_button(self):
        try:
            xpath = "/div/div[1]/div/main/div[1]/div/div/div/div/header/div/div[2]/div[2]/a"
            WebDriverWait(self.browser, self.delay).until(
                EC.element_to_be_clickable((By.XPATH, xpath))
            )
            button = self.browser.find_element(By.XPATH, xpath)
            button.click()

        except TimeoutException:
            self._exit_by_time_out()

        except ElementClickInterceptedException:
            pass

    # ... (rest of the methods)

    def _change_focus_to_pop_up(self) -> bool:
        main_window = next(
            filter(lambda handle: handle != self.browser.current_window_handle, self.browser.window_handles),
            None
        )

        if main_window:
            self.browser.switch_to.window(main_window)
            return True

        return False

    # ... (rest of the methods)

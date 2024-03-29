# Selenium: automation of browser

import atexit
import os
import random
import time
from pathlib import Path
from typing import Dict, Union

import selenium.common.exceptions as SeleniumExceptions
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait
from undetected_chromedriver.v2 import Chrome, ChromeOptions


class TinderBot:
    """TinderBot class to automate tinder actions."""

    class Session:
        """Session class to handle tinder sessions."""

        HOME_URL = "https://www.tinder.com/app/recs"

        def __init__(
            self,
            headless: bool = False,
            store_session: bool = True,
            proxy: Union[str, None] = None,
            user_data: Union[str, bool] = False,
        ):
            self.email = None
            self.may_send_email = False
            self.session_data = {"duration": 0, "like": 0, "dislike": 0, "superlike": 0}

            start_session = time.time()

            @atexit.register
            def cleanup():
                # End session duration
                seconds = int(time.time() - start_session)
                self.session_data["duration"] = seconds

                # add session data into a list of messages
                lines = []
                for key in self.session_data:
                    message = "{}: {}".format(key, self.session_data[key])
                    lines.append(message)

                # print out the statistics of the session
                try:
                    box = self._get_msg_box(lines=lines, title="Tinderbotz")
                    print(box)
                finally:
                    print("Started session: {}".format(self.started))
                    y = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
                    print("Ended session: {}".format(y))

                # Close browser properly
                self.close_browser()

            # Go further with the initialisation
            # Setting some options of the browser here below

            options = ChromeOptions()

            # Create empty profile to avoid annoying Mac Popup
            if store_session:
                if not user_data:
                    user_data = f"{Path().absolute()}/chrome_profile/"
              

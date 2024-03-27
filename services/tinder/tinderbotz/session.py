# Selenium: automation of browser

import atexit
import os
import random
import time
from pathlib import Path
from typing import List, Union

import undetected_chromedriver.v2 as uc
from selenium.common.exceptions import (
    NoSuchElementException,
    TimeoutException,
    ElementNotVisibleException,
)
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait

import undetected_chromedriver.v2 as uc  # type: ignore
from tinderbotz.addproxy import get_proxy_extension  # type: ignore
from tinderbotz.helpers.constants_helper import Printouts  # type: ignore
from tinderbotz.helpers.email_helper import EmailHelper  # type: ignore


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
                self.browser.quit()

            # Go further with the initialisation
            # Setting some options of the browser here below

            options = uc.ChromeOptions()

            # Create empty profile to avoid annoying Mac Popup
            if store_session:
                if not user_data:
                    user_data = f"{Path().absolute()}/chrome_profile/"
                if not os.path.isdir(user_data):
                    os.mkdir(user_data)

                Path(f"{user_data}First Run").touch()
                options.add_argument(f"--user-data-dir={user_data}")

            options.add_argument("--no-first-run --no-service-autorun --password-store=basic")
            options.add_argument("--lang=en-GB")

            if headless:
                options.headless = True

            if proxy:
                if "@" in proxy:
                    parts = proxy.split("@")

                    user = parts[0].split(":")[0]
                    pwd = parts[0].split(":")[1]

                    host = parts[1].split(":")[0]
                    port = parts[1].split(":")[1]

                    extension = get_proxy_extension(
                        PROXY_HOST=host, PROXY_PORT=port, PROXY_USER=user, PROXY_PASS=pwd
                    )
                    options.add_extension(extension)
                else:
                    options.add_argument(f"--proxy-server=http://{proxy}")

            # Getting the chromedriver from cache or download it from internet
            print("Getting ChromeDriver ...")
            self.browser = uc.Chrome(options=options)  # ChromeDriverManager().install(),
            # self.browser = webdriver.Chrome(options=options)
            # self.browser.set_window_size(1250, 750)

            # clear the console based on the operating system you're using
            # os.system('cls' if os.name == 'nt' else 'clear')

            # Cool banner
            print(Printouts.BANNER.value)
            time.sleep(1)

            self.started = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
            print("Started session: {}\n\n".format(self.started))

        def set_custom_location(self, latitude, longitude, accuracy: str = "100%"):
            """Set custom location."""
            params = {
                "latitude": latitude,
                "longitude": longitude,
                "accuracy": int(accuracy.split("%")[0]),
            }

           

from instagrapi import Client
from instagrapi.exceptions import (
    BadPassword,
    ChallengeRequired,
    FeedbackRequired,
    LoginRequired,
    PleaseWaitFewMinutes,
    RecaptchaChallengeForm,
    ReloginAttemptExceeded,
    SelectContactPointRecoveryForm,
    AccountTemporarilyBlocked,
    ActionBlocked,
    TemporarilyBlocked,
)

class Account:
    """
    A class representing an Instagram account.
    """

    def __init__(self, username: str, password: str):
        """
        Initialize the Account object with a username and password.

        :param username: The Instagram username.
        :param password: The Instagram password.
        """
        self.username = username
        self.password = password

    def get_client(self) -> Client:
        """
        Get an authenticated Client object for the account.

        :return: An authenticated Client object.
        """

        def handle_exception(client, e):
            if isinstance(e, BadPassword):
                client.logger.exception(e)
                client.set_proxy(self.next_proxy().href)
                if client.relogin_attempt > 0:
                    self.freeze(str(e), days=7)
                    raise ReloginAttemptExceeded(e)
                client.settings = self.rebuild_client_settings()
                return self.update_client_settings(client.get_settings())
            elif isinstance(e, LoginRequired):
                client.logger.exception(e)
                client.relogin()
                return self.update_client_settings(client.get_settings())
            elif isinstance(e, ChallengeRequired):
                api_path = client.last_json.get("challenge", {}).get("api_path")
                if api_path == "/challenge/":
                    client.set_proxy(self.next_proxy().href)
                    client.settings = self.rebuild_client_settings()
                else:
                    try:
                        client.challenge_resolve(client.last_json)
                    except ChallengeRequired as e:
                        self.freeze("Manual Challenge Required", days=2)
                        raise e
                    except (
                        ChallengeRequired,
                        SelectContactPointRecoveryForm,
                        RecaptchaChallengeForm,
                    ) as e:
                        self.freeze(str(e), days=4)
                        raise e
                return True
            elif isinstance(e, FeedbackRequired):
                message = client.last_json["feedback_message"]
                if "This action was blocked. Please try again later" in message:
                    self.freeze(message, hours=12)
                elif "We restrict certain activity to protect our community" in message:
                    self.freeze(message, hours=12)
                elif "Your account has been temporarily blocked" in message:
                    self.freeze(message)
            elif isinstance(e, PleaseWaitFewMinutes):
                self.freeze(str(e), hours=1)
            elif isinstance(e, ReloginAttemptExceeded):
                self.freeze(str(e), days=7)
            elif isinstance(e, RecaptchaChallengeForm):
                self.freeze("Recaptcha Challenge Required", days=4)
            elif isinstance(e, SelectContactPointRecoveryForm):
                self.freeze("Contact Point Recovery Required", days=4)
            elif isinstance(e, AccountTemporarilyBlocked):
                self.freeze(str(e), hours=12)
            elif isinstance(e, ActionBlocked):
                self.freeze(str(e), hours=12)
            elif isinstance(e, TemporarilyBlocked):
                self.freeze(str(e), hours=12)
            raise e

        cl = Client()
        cl.handle_exception = handle_exception
        cl.login(self.username, self.password)
        return cl

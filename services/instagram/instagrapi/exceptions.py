class InstagramError(ClientError):
    def __init__(self, *args, **kwargs):
        self.status_code = None
        super().__init__(*args, **kwargs)

    def __str__(self):
        return f"{self.error_title}: {self.message}"


class ClientUnknownError(InstagramError):
    pass


class WrongCursorError(InstagramError):
    message = "You specified a non-existent cursor"


class ClientStatusFail(InstagramError):
    pass


class ResetPasswordError(InstagramError):
    pass


class GenericRequestError(InstagramError):
    """Sorry, there was a problem with your request"""


class ClientGraphqlError(InstagramError):
    """Raised due to graphql issues"""


class ClientJSONDecodeError(InstagramError):
    """Raised due to json decoding issues"""


class ClientConnectionError(InstagramError):
    """Raised due to network connectivity-related issues"""


class ClientBadRequestError(InstagramError):
    """Raised due to a HTTP 400 response"""


class ClientUnauthorizedError(InstagramError):
    """Raised due to a HTTP 401 response"""


class ClientForbiddenError(InstagramError):
    """Raised due to a HTTP 403 response"""


class ClientNotFoundError(InstagramError):
    """Raised due to a HTTP 404 response"""


class ClientThrottledError(InstagramError):
    """Raised due to a HTTP 429 response"""


class ClientRequestTimeout(InstagramError):
    """Raised due to a HTTP 408 response"""


class ClientIncompleteReadError(InstagramError):
    """Raised due to incomplete read HTTP response"""


class ClientLoginRequired(InstagramError):
    """Instagram redirect to https://www.instagram.com/accounts/login/"""


class ReloginAttemptExceeded(InstagramError):
    pass


class PrivateError(InstagramError):
    """For Private API and last_json logic"""


class NotFoundError(PrivateError):
    reason = "Not found"


class FeedbackRequired(PrivateError):
    pass


class ChallengeError(PrivateError):
    challenge_type = None
    step = None
    form_name = None
    message_template = None
    message_params = None
    form_data = None
    form_response = None
    form_status_code = None
    form_message = None
    form_error_title = None
    form_error_body = None
    form_error_reason = None
    form_error_logout_reason = None

    def __init__(self, *args, **kwargs):
        self.form_response = None
        self.form_status_code = None
        self.form_message = None
        self.form_error_title = None
        self.form_error_body = None
        self.form_error_reason = None
        self.form_error_log

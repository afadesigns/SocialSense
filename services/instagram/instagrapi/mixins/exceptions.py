class ClientError(Exception):
    def __init__(self, message=None, title=None, response=None, **kwargs):
        self.title = title
        self.response = response
        self.code = None
        self.message = message or ""
        if self.message:
            self.message = str(self.message)
        else:
            self.message = "{title} ({body})".format(
                title=getattr(self, "reason", "Unknown"),
                body=getattr(self, "error_type", vars(self)),
            )
        self.error_type = type(self).__name__
        self.reason = getattr(self, "reason", "Unknown")
        self.logout_reason = getattr(self, "logout_reason", None)
        self.status = getattr(self, "status", None)
        super().__init__(self.message)
        if self.response:
            self.code = self.response.status_code

class ClientGraphqlError(ClientError):
    pass

class ClientJSONDecodeError(ClientError):
    pass

class ClientConnectionError(ClientError):
    pass

class ClientBadRequestError(ClientError):
    pass

class ClientUnauthorizedError(ClientError):
    pass

class ClientForbiddenError(ClientError):
    pass

class ClientNotFoundError(ClientError):
    pass

class ClientThrottledError(ClientError):
    pass

class ClientRequestTimeout(ClientError):
    pass

class ClientIncompleteReadError(ClientError):
    pass

class ClientLoginRequired(ClientError):
    pass

class ReloginAttemptExceeded(ClientError):
    pass

class PrivateError(ClientError):
    pass

class NotFoundError(PrivateError):
    pass

class FeedbackRequired(PrivateError):
    pass

class ChallengeError(PrivateError):
    pass

class ChallengeRedirection(ChallengeError):
        pass

class ChallengeRequired(ChallengeError):
    pass

class ChallengeSelfieCaptcha(ChallengeError):
    pass

class ChallengeUnknownStep(ChallengeError):
    pass

class SelectContactPointRecoveryForm(ChallengeError):
    pass

class RecaptchaChallengeForm(ChallengeError):
    pass

class SubmitPhoneNumberForm(ChallengeError):
    pass

class LegacyForceSetNewPasswordForm(ChallengeError):
    pass

class RateLimitError(PrivateError):
    pass

class ProxyAddressIsBlocked(PrivateError):
    pass

class BadPassword(PrivateError):
    pass

class BadCredentials(PrivateError):
    pass

class PleaseWaitFewMinutes(PrivateError):
    pass

class UnknownError(PrivateError):
    pass

class TrackNotFound(NotFoundError):
    pass

class MediaError(PrivateError):
    pass

class MediaNotFound(NotFoundError, MediaError):
    pass

class StoryNotFound(NotFoundError, MediaError):
    pass

class UserError(PrivateError):
    pass

class UserNotFound(NotFoundError, UserError):
    pass

class CollectionError(PrivateError):
    pass

class CollectionNotFound(NotFoundError, CollectionError):
    pass

class DirectError(PrivateError):
    pass

class DirectThreadNotFound(NotFoundError, DirectError):
    pass

class DirectMessageNotFound(NotFoundError, DirectError):
    pass

class HashtagNotFound(NotFoundError, HashtagError):
    pass

class LocationError(PrivateError):
    pass

class LocationNotFound(NotFoundError, LocationError):
    pass

class TwoFactorRequired(PrivateError):
    pass

class HighlightNotFound(NotFoundError, PrivateError):
    pass

class NoteNotFound(NotFoundError):
    pass

class PrivateAccount(PrivateError):
    pass

class InvalidTargetUser(PrivateError):
    pass

class InvalidMediaId(PrivateError):
    pass

class MediaUnavailable(PrivateError):
    pass

class AlbumConfigureError(ClientError):
    """Exception raised when an album configuration fails."""

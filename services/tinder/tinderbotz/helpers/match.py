from tinderbotz.helpers.geomatch import Geomatch

class Match(Geomatch):
    """
    A Match object represents a match with another user on Tinder.
    It contains information about the user and a unique chatroom ID.
    """

    def __init__(
        self,
        name,
        chatid,
        age,
        work,
        study,
        home,
        gender,


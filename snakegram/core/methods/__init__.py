from .auth import Auth
from .common import Common
from .updates import Updates
from .messages import Messages

class Methods(Auth, Common, Updates, Messages):
    pass
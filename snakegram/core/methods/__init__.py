from .auth import Auth
from .common import Common
from .updates import Updates
from .messages import Messages
from .upload import Upload


class Methods(
    Auth,
    Common,
    Updates,
    Messages,
    Upload
):
    pass
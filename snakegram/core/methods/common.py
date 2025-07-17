import typing as t

from ...tl import types, functions
from ...errors import UnauthorizedError

if t.TYPE_CHECKING:
    from ..telegram import Telegram


class Common:
    async def get_me(self: 'Telegram') -> t.Optional[types.User]:
        """
        Gets the currently logged-in user or bot, or `None` if not authenticated.

        Returns:
            Optional[types.User]: The current user or bot, or `None`.

        Example:
        ```python
        me = await client.get_me()
        if me:
            print(f"You're logged in as {helper.get_display_name(me)!r}")
        else:
            print("You're not logged in")
        """

        try:
            result = await self(
                functions.users.GetUsers(
                    [types.InputUserSelf()]
                )
            )

        except UnauthorizedError:
            self._authorized = False
        
        else:        
            self._authorized = True
            return result[0]

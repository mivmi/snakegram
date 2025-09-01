from inspect import cleandoc as _cleandoc

__version_info__ = (1, 0, 0, 'dev', 4)


def _get_version(version_info: tuple) -> str:
    """
    Converts a version_info to a [PEP 440](https://peps.python.org/pep-0440/) version string.

    Expected formats:
        (epoch, major, minor, micro, release-level, serial)
        (major, minor, micro, release-level, serial)
        (major, minor, micro)

    Examples:
        (1, 2, 3)                          -> "1.2.3"
        (1, 2, 3, 'beta', 2)               -> "1.2.3b2"
        (1, 2, 3, 'final')                 -> "1.2.3"
        (1, 2, 3, 'post', 1)               -> "1.2.3.post1"
        (2, 1, 2, 3, 'rc', 1)              -> "2!1.2.3rc1"
    """

    epoch = None
    if len(version_info) >= 6:
        tail = version_info[4:]
        epoch, major, minor, micro = version_info[:4]

    else:
        tail = version_info[3:]
        major, minor, micro = version_info[:3]

    if not all(isinstance(x, int) for x in (major, minor, micro)):
        raise ValueError('major, minor, micro must be integers')

    levels = {
        'alpha': 'a',
        'beta': 'b',
        'rc': 'rc',
        'dev': '.dev',
        'post': '.post',
        'final': ''
    }
        
    version = f'{major}.{minor}.{micro}'
    if tail:
        release_level = tail[0]
        serial = tail[1] if len(tail) > 1 else None

        if release_level not in levels:
            raise ValueError(f'Invalid release level: {release_level!r}')

        suffix = levels[release_level]
        if suffix:
            if serial is None:
                raise ValueError(f'Serial required for release level: {release_level}')
            version += f'{suffix}{serial}'

    if epoch is not None:
        if not isinstance(epoch, int):
            raise ValueError('Epoch must be an integer')
        version = f'{epoch}!{version}'

    return version



__author__ = 'Milad <https://github.com/mivmi>'
__version__ = _get_version(__version_info__)
__license__ = _cleandoc(
    f'''
    Copyright (C) 2025-present {__author__}

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
    '''
)
__copyright__ = __license__.split('\n', maxsplit=1)[0]
__update_command__ = 'pip install -U snakegram'

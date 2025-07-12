import os
from shutil import rmtree
from .constants import ROOT, PKG_PATH
from .errors_converter import errors_converter
from .type_language_converter import type_language_converter


def pkg_path(*path: str):
    return os.path.join(PKG_PATH, *path)
 
def resource_path(*path: str):
    return os.path.join(ROOT, 'resource', *path)


_tl_folder = pkg_path('tl')
_errors_folder = pkg_path('errors', 'rpc_errors')

def clean():
    rmtree(_tl_folder, ignore_errors=True)
    rmtree(_errors_folder, ignore_errors=True)

def generate_code():
    clean() # remove old

    errors = errors_converter(
        resource_path('errors.tsv'),
        folder=_errors_folder
    )

    type_language_converter(
        [
            (_tl_folder, resource_path('schema.tl'), True),
            (pkg_path('tl', 'mtproto'), resource_path('mtproto.tl'), True),
            (pkg_path('tl', 'secret'), resource_path('secret-chat.tl'), False) 
        ],
        errors=errors
    )


__all__ = [
    'clean',
    'generate_code',
    'pkg_path', 'resource_path'
]

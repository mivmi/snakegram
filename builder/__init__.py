import os
import typing as t
from shutil import rmtree
from .constants import ROOT, PKG_PATH
from .errors_converter import errors_converter
from .type_language_converter import type_language_converter


def pkg_path(*path: str):
    return os.path.join(PKG_PATH, *path)
 
def resource_path(*path: str):
    return os.path.join(ROOT, 'builder', 'resource', *path)


TL_FOLDER = pkg_path('tl')
ERRORS_FOLDER = pkg_path('errors', 'rpc_errors')

def clean():
    rmtree(TL_FOLDER, ignore_errors=True)
    rmtree(ERRORS_FOLDER, ignore_errors=True)

def generate_code():
    clean() # remove old

    errors = errors_converter(
        resource_path('errors.tsv'),
        folder=ERRORS_FOLDER
    )

    type_language_converter(
        [
            (TL_FOLDER, resource_path('schema.tl'), True),
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

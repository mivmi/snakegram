from builder import generate_code
from setuptools.build_meta import *
from setuptools.build_meta import \
    get_requires_for_build_wheel as _get_requires_for_build_wheel



def get_requires_for_build_wheel(config_settings=None):
    generate_code()
    return _get_requires_for_build_wheel(config_settings)

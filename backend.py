from maturin import *
from builder import generate_code


_get_requires_for_build_wheel = get_requires_for_build_wheel

def get_requires_for_build_wheel(config_settings=None):
    generate_code()
    return _get_requires_for_build_wheel(config_settings)

import re
import os
import csv

from . import utils, constants


def to_error_name(message: str):
    if message.startswith('2'):
        message = 'Two_' + message[1:]

    result = ''.join(
        [
            e.title()
            for e in re.sub(r'{\S+}', '_', message).split('_')
        ]
    )
    return result + 'Error'

def get_file_path(error_code: int, folder: str):
    base_name = constants.BASE_ERROR_CLASS[error_code]
    
    return os.path.join(
        folder,
        utils.snake_case(base_name) + 's.py'
    )


def get_error_pattern(message: str):
    names = []
    def wrapper(value):
        nonlocal names
        name = value.group(1)
        names.append(name)
        return fr'(?P<{name}>\d+)'

    result = re.sub(r'{(\S+)}', wrapper, message)
    
    if names:
        result = f"re.compile(r'{result}')"
    
    else:
        result = repr(result)

    return names, result


def add_class(
    code: int,
    message: str,
    description: str,
    module: 'utils.Module'
):

    result = utils.PyFormatter()

    # Convert the message into a valid error class name
    err_name = to_error_name(message)
    base_name = constants.BASE_ERROR_CLASS[code]
    variables, pattern = get_error_pattern(message)

    if variables:
        # add necessary imports for regex
        module.add_import('re')

    module.add_import(base_name, module=constants.BASE_ERROR_PATH)

    # start defining the new error class
    result(f'class {err_name}')
    result.shaper(base_name, f'pattern={pattern}')

    with result.new(':') as body:
        body(f'"""\n{base_name} ({code}): `{message}`\n"""\n\n')

        body('def __init__')
        body.shaper(
            'self',
            'request',
            *(
                f'{name}: int = 0'
                for name in variables
            )
        )

        with body.new(':') as init_body:
            for name in variables:
                init_body(f'self.{name} = {name}\n')

            if variables:
                init_body('\n')

            # Call the superclass constructor
            init_body('super().__init__')
            init_body.shaper(
                'request',
                f'f{description!r}' if variables else f'{description!r}'
            )

    module.add_class(err_name, result.content.strip())
    return err_name


def errors_converter(filename: str, folder: str):
    result = {}
    modules = {}
    
    def get_or_create_module(path: str) -> utils.Module:
        result = modules.get(path)

        if result is None:
            modules[path] = result = utils.Module(path)

        return result

    init = utils.Module(os.path.join(folder, '__init__.py'))

    with open(filename, 'r', encoding='utf-8') as fp:
        for code, message, description in csv.reader(fp, delimiter='\t'):
            code = int(code)
            path = get_file_path(code, folder)

            name = add_class(
                code,
                message=message,
                description=description,
                module=get_or_create_module(path)
            )
            init.add_import(name, module=path)
    
            if code not in result:
                result[code] = {}
            
            result[code][name] = description

    init.write()
    for module in modules.values():
        module.write()

    return result
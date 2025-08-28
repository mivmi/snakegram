# Minimal TL Parsing
# This parser only implements TL rules that have been encountered so far 
# Unused rules are ignored to reduce the number of grammar definitions
# For simplicity and easier implementation
# some rules may differ slightly from the official documentation
import re
import os
import ast
import sys
import builtins
import typing as t
from zlib import crc32

from . import utils, constants
from .parser import BaseParser, lexer, grammar


class TypeLexer(lexer.BaseLexer):
    DOT = '.'
    HASH = '#'
    COLON = ':'
    LANGLE = '<'
    RANGLE = '>'
    EQUALS = '='
    SEMICOLON = ';'
    EXCL_MARK = '!'
    PERCENT_MARK = '%'
    QUESTION_MARK = '?'

    OPEN_BRACE = '{'
    CLOSE_BRACE = '}'
    OPEN_BRACKET = '['
    CLOSE_BRACKET = ']'

    THREE_DASH = '---'

    @lexer.token('WS', ignore=True)
    def ws_handler(self, value: str):
        if value.isspace():
            return value

    @lexer.token('HEX')
    def hex_handler(self, value: str):
        if value == self.HASH:
            buffer = ''
            for next_char in self.iter():
                if not (
                    '0' <= next_char <= '9'
                    or 'a' <= next_char <= 'f'
                    or 'A' <= next_char <= 'F'
                ):
                    self.set_position(-1)
                    break

                buffer += next_char

            if buffer:
                return int(buffer, base=16)

    @lexer.token('NUM')
    def number_handler(self, value: str):
        if value.isdigit():
            buffer = value
            for next_char in self.iter():
                if not next_char.isdigit():
                    self.set_position(position=-1)
                    break

                buffer += next_char

            return int(buffer)

    @lexer.token('IDENT')
    def identifier_handler(self, value: str):
        if value.isidentifier():
            buffer = value
            for next_char in self.iter():
                buffer += next_char
                if not buffer.isidentifier():
                    buffer = buffer[:-1]
                    self.set_position(-1)
                    break

            return buffer

    @lexer.token('MULTI_LINE_COMMENT')
    def multi_line_comment_handler(self, value: str):
        if value == '/':
            if self.read(1) != '*':
                self.set_position(-1)

            else:
                close = '*/'
                comment = ''
                position = self.position

                for next_char in self.iter():
                    comment += next_char

                    if comment[-2:] == close:
                        break

                else:
                    self.set_position(position - 1, current=False)
                    raise SyntaxError(f'Unterminated multi-line comment: missing closing {close!r}.')

                return comment[:-2].strip()

    @lexer.token('SINGLE_LINE_COMMENT')
    def single_line_comment_handler(self, value: str):
        if value == '/':
            if self.read(1) != '/':
                self.set_position(-1)

            else:
                return self.readline().strip()

class TypeParser(BaseParser):
    START = 'root'
    LEXER = TypeLexer

    @grammar('(`IDENT` `DOT`!)? `IDENT`', name='namespace')
    def parse_namespace(self, space, value):
        return {
            '_': 'namespace',
            'name': value.value,
            'namespace': space.value if space else None
        }

    # sub type section
    @grammar('(`EXCL_MARK` | `PERCENT_MARK`)? namespace', name='sub_type')
    def parse_simple_type(self, modifier, value):
        name = value['name']
        namespace = value['namespace']

        if namespace is None:
            py_type = constants.BASE_TYPES.get(name)
            if py_type:
                return {
                    '_': 'base_type',
                    'name': name,
                    'py_type': py_type
                }
        if modifier is not None:
            modifier = modifier.value
    
        return {'_': 'type',
                'name': name,
                'modifier': modifier,
                'namespace': namespace}

    # type section
    @grammar('`HASH`!', name='type')
    def parse_flag_type(self):
        return {'_': 'flag'}

    @grammar('sub_type', name='type')
    def sub_type_as_type(self, value):
        return value

    @grammar('`IDENT` `LANGLE`! sub_type `RANGLE`!', name='type')
    def parse_vector_type(self, name, sub_type):
        # generic types are only used in `vector`, so rename it to `vector_type`
        return {'_': 'vector_type', 'name': name.value, 'type': sub_type}

    @grammar('`IDENT` `DOT`! `NUM` `QUESTION_MARK`! type', name='flagged_type')
    def parse_flagged_type(self, name, value, sub_type):
        return {'_': 'flagged_type',
                'name': name.value,
                'value': value.value, 'type': sub_type}

    # parameters section
    @grammar('`OPEN_BRACE`! `IDENT` `COLON`! `IDENT` `CLOSE_BRACE`!', name='generic')
    def parse_generic(self, name, generic_type):
        return {'_': 'generic', 'name': name.value, 'type': generic_type.value}

    @grammar('parameters? `IDENT` `COLON`! (type | flagged_type)', name='parameters')
    def parse_parameters(self, params, name, param_type):
        result = params or []
        result.append(
            {
                'name': name.value,
                'type': param_type
            }
        )
        return result

    @grammar('namespace `HEX`? (generic? parameters)? `EQUALS`! type `SEMICOLON`!', name='object')
    def parse_object(self, name, object_id, generic, parameters, result_type):
        if generic:
            if (
                result_type['_'] == 'type'
                and result_type['name'] == generic['name']
            ):
                result_type = generic

            for index, param in enumerate(parameters):
                if (
                    param['type']['_'] == 'type'
                    and param['type']['name'] == generic['name']
                ):
                    parameters[index]['type'] = {
                        **generic,
                        'modifier': param['type']['modifier']
                    }

        if object_id is not None:
            object_id = object_id.value

        return {
            '_': 'object',
            'name': name,
            'generic': generic,
            'object_id': object_id,
            'parameters': parameters or [],
            'result_type': result_type
        }

    # custom section
    @grammar('`MULTI_LINE_COMMENT` object', name='object')
    def parse_object_with_docstring(self, comment, data):
        errors = {}
        parameters = {}
        description = []
        parsing_description = True

        for line in comment.value.splitlines():
            try:
                if line.startswith('@'):
                    name, value = line[1:].split(maxsplit=1)

                    if name.isidentifier():
                        parameters[name] = value.strip()
                        parsing_description = False

                elif line.startswith('$'):
                    code, name = line[1:].split(',', maxsplit=1)

                    code = int(code.strip())
                    if code not in errors:
                        errors[code] = []

                    errors[code].append(name.strip())
                    parsing_description = False

            except ValueError: # unpack error, invalid literal (int)
                pass

            if parsing_description:
                description.append(line)

        if errors:
            data['$'] = errors

        if description:
            data['@'] = '\n'.join(description).strip()

        if parameters:
            for param in data['parameters']:
                param['@'] = parameters.get(param['name'])

        return data

    @grammar('`SINGLE_LINE_COMMENT`', name='layer')
    def parse_layer(self, comment):
        result = re.match(
            r'@(layer|secret-chat-layer)\s*(\d+)',
            comment.value,
            flags=re.IGNORECASE
        )
        if result:
            return {'_': result.group(1), 'value': int(result.group(2))}

    @grammar('`THREE_DASH`! `IDENT` `THREE_DASH`!', name='section')
    def parse_section(self, section):
        return {'_': 'section', 'value': section.value}

    @grammar('(layer | section | object) root?', name='root')
    def root_handler(self, value, root=None):
        if value:
            if not isinstance(value, list):
                value = [value]

            root = root or []
            root = value + root

        return root

def is_bool(data: dict) -> bool:
    if data['_'] == 'flagged_type':
        return is_bool(data['type'])

    else:
        return data.get('name') in constants.BOOLEAN_TYPES

def to_hex(value: t.Union[str, int]):
    if isinstance(value, str):
        value = crc32(value.encode('utf-8'))

    return hex(value).upper()

def to_byte(value: int):
    return value.to_bytes(4, byteorder='little')

# helpers

def get_file_path(
    data: dict,
    is_type: bool = True,
    separate: bool = True,
    namespace: t.Optional[str] = None
):
    """
    Determines the file path for a class based on parsed data.

    This function takes parsed data from the parser and determines the appropriate 
    file path where the corresponding class should be stored. If the object belongs 
    to the `types` category (`is_type=True`), it is placed in `"types"`, otherwise, 
    it is placed in `"functions"` (if separate is `True`).


    Example:
        >>> data = {..., "result_type": {..., "name": "MyClass"}}
        >>> get_file_path(data)
        "types/my_class.py"
    """
    node_name = data.get('_')

    if node_name == 'object':
        if is_type:
            data = data['result_type']
            base = 'types'

        else:
            data = data['name']
            base = 'functions'

    else:
        base = 'types'
    
    if not separate:
        base = None
    
    if namespace is not None:
        base = (
            os.path.join(namespace, base)
            if base else
            namespace
        )

    file_name = utils.snake_case(data['name'])
    target_ns = data.get('namespace')

    if target_ns is not None:
        base = (
            os.path.join(base, target_ns)
            if base else
            target_ns
        )

    if file_name in constants.FILES_TO_MOVE_INTO_INIT:
        base = (
            os.path.join(base, file_name)
            if base else 
            file_name
        )
        file_name = '__init__'

    py_file = f'{file_name}.py'

    return (
        os.path.join(base, py_file)
        if base else 
        py_file
    )   

def get_family_name(name: str, namespace: t.Optional[str] = None):
    result = utils.title_case(
        name
        if namespace is None else
        f'{namespace}_{name}'
    )
    result = result.rstrip('_')  # TypeTrue_

    return (
        f'{result}Type' # TypeError
        if hasattr(builtins, f'Type{result}') else
        f'Type{result}'
    )

def get_type_annotation(
    data: dict,
    name: str,
    module: 'utils.Module',
    separate: bool = True,
    namespace: t.Optional[str] = None,
    force_import: bool = False
):

    if is_bool(data):
        return 'bool'

    type_name = data.get('_')

    if type_name == 'type':
        if data['name'] == 'Object':
            module.add_import(
                constants.BASE_CLASS,
                module=constants.BASE_CLASS_PATH,
                type_checking=True
            )

            return repr(constants.BASE_CLASS)

        boxed = not data['name'].islower()
        class_name = get_family_name(data['name'], data['namespace'])
        force_import = (
            force_import
            or (
                not boxed
                or data.get('modifier') == '%'
            )
        )

        module.add_import(
            class_name,
            module=get_file_path(
                data,
                separate=separate,
                namespace=namespace
            ),
            type_checking=not force_import
        )

        return class_name if force_import else repr(class_name)

    elif type_name == 'generic':
        name = data['name']

        module.add_import(
            constants.BASE_FUNCTION_CLASS,
            module=constants.BASE_CLASS_PATH
        )
        module.add_import('TypeVar', module='typing')
        module.add_variable(name, f'TypeVar({name!r})')

        return f'{constants.BASE_FUNCTION_CLASS}[{name}]'

    elif type_name == 'base_type':
        return data['py_type']
    
    elif type_name == 'vector_type':

        sub_type = get_type_annotation(
            data['type'],
            name=name,
            module=module,
            separate=separate,
            namespace=namespace,
            force_import=force_import
        )
        module.add_import('List', module='typing')
        
        return f'List[{sub_type}]'
    
    elif type_name == 'flagged_type':
        sub_type = get_type_annotation(
            data['type'],
            name=name,
            module=module,
            separate=separate,
            namespace=namespace
        )

        module.add_import('Optional', module='typing')
        return f'Optional[{sub_type}]'

def is_random_id(parameter: dict):
    return utils.safe_name(parameter['name']) == 'random_id'

def sort_init_parameters(parameter: dict):
    if parameter['type']['_'] == 'flagged_type':
        return 1

    if is_random_id(parameter):
        return 2

    return 0
        

# creators
def create_class(
    tree: dict,
    module: 'utils.Module',
    errors: t.Optional[dict] = None,
    is_type: bool = True,
    separate: bool = True,
    namespace: t.Optional[str] = None
):
    name = utils.title_case(
        value=tree['name']['name']
    )
    result = utils.PyFormatter()
    
    family = None
    result_type = tree['result_type']

    if result_type['_'] == 'type':
        family = get_family_name(
            result_type['name'],
            result_type['namespace']
        )

    if is_type:
        types = module.get_variable(family, level=2)

        if types is None:
            module.add_variable(
                family,
                value=name,
                level=2
            )

        else:
            # check types is Union
            node = ast.parse(types, mode='eval').body

            if isinstance(node, ast.Name):
                types = [node.id]
                module.add_import('Union', module='typing')

            elif isinstance(node, ast.Subscript):
                slice_value = node.slice

                # python <= 3.8 wraps the slice in ast.Index, removed in 3.9 <= python
                if (
                    sys.version_info < (3, 9)
                    and isinstance(slice_value, ast.Index)
                ):
                    slice_value = slice_value.value

                if isinstance(slice_value, ast.Tuple):
                    types = [e.id for e in slice_value.elts]

                else:
                    types = [slice_value.id] # single

            else:
                types = []

            fmt = utils.PyFormatter('Union')
            fmt.shaper(*types, name, open='[', close=']')
            module.add_variable(family, fmt.content, level=2)

        base = f'{constants.BASE_CLASS}, family={family!r}'

        module.add_import(
            constants.BASE_CLASS,
            module=constants.BASE_CLASS_PATH
        )

    else:
        base = get_type_annotation(
            tree['result_type'],
            name='',
            module=module,
            separate=separate,
            namespace=namespace,
            force_import=True
        )

        if not base.startswith(constants.BASE_FUNCTION_CLASS):
            base = f'{constants.BASE_FUNCTION_CLASS}[{base}]'

        module.add_import(
            constants.BASE_FUNCTION_CLASS,
            module=constants.BASE_CLASS_PATH
        )

    with result.new(f'class {name}({base}):') as body:
        description = tree.get('@')
        
        if description is not None:
            body(f'"""\n{description}\n')
            
            possible_errors = tree.get('$')
            if possible_errors is not None:
                with body.new('\nRaises:') as raises:
                    for code, err_names in possible_errors.items():
                        if code < 0:
                            continue

                        for err_name in err_names:
                            if errors:
                                raises(f'`{code}`{err_name}: {errors[code][err_name]}\n')

                            else:
                                raises(f'{code}: {err_name}\n')

                    body.trim_trailing_whitespace()

            body('"""\n\n')

        if tree['object_id'] is not None:
            object_id = tree['object_id']
            body(f'_id = {to_hex(object_id)}\n')

        if is_type:
            body(f'_group_id = {to_hex(family)}\n')
        
        else:
            if family is not None: # not generic
                body(f'_result_id = {to_hex(family)}\n')

        if tree['parameters']:
            body(
                '\n',
                create_init_function(
                    tree,
                    module=module,
                    separate=separate,
                    namespace=namespace
                )
            )

        body(
            '\n\n',
            create_to_bytes_function(
                tree,
                module=module
            )
        )

        if is_type:
            body(
                '\n\n',
                create_from_reader_function(
                    tree,
                    module=module
                )
            )

    return name, family, result.content.strip()

def create_init_function(
    tree: dict,
    module: 'utils.Module',
    separate: bool = True,
    namespace: t.Optional[str] = None
):

    result = utils.PyFormatter()
    docstring = utils.PyFormatter()

    result('\ndef __init__')
    with result.new(':\n') as body:
        arguments = ['self']

        # The `flag` parameters do not require an argument and are assigned values  
        # from their corresponding arguments.  
        # Therefore, they must be removed from the argument list and managed by `BASE_CLASS`.  
        # Arguments that use these `flag` parameters are optional and may have no value.  
        # So, they should be moved to the end of the arguments to allow setting a default value
        
        for parameter in filter(
            lambda param: param['type']['_'] != 'flag', # Exclude flags
            sorted(
                tree['parameters'],
                key=sort_init_parameters # Optional arguments come last
            )
        ):
            name = utils.safe_name(parameter['name'])

            default = None
            if parameter['type']['_'] == 'flagged_type':
                default = (
                    'False'
                    if is_bool(parameter['type']) else 'None'
                )

            annotation = get_type_annotation(
                parameter['type'],
                name=name,
                module=module,
                separate=separate,
                namespace=namespace
            )
            
            # random_id
            if is_random_id(parameter):
                default = 'None'

                def create_random_value(param_type):
                    is_bytes = param_type['name'] == 'bytes'
                    base_type = (
                        'long'
                        if is_bytes else
                        param_type['name']
                    )

                    if base_type in ('int', 'long'):
                        class_name = base_type.title()
                        module.add_import(class_name, module=constants.BYTE_UTILS_PATH)
                
                        instance = f'{class_name}()'
                        return f'{class_name}.to_bytes({instance})' if is_bytes else instance

                    raise ValueError(f'Unsupported random_id type: {base_type!r}')


                base_type = parameter['type']['_']
                if base_type == 'base_type':
                    creator = create_random_value(parameter['type'])

                elif base_type == 'vector_type': # 6d74da08/6c750de1
    
                    element = create_random_value(
                        parameter['type']['type']
                    )
                    creator = f'[{element} for _ in id]'

                else:
                    raise ValueError(f'Unsupported random_id type: {base_type!r}')

                body(f'self.{name} = {creator} if random_id is None else random_id\n')

            else:
                body(f'self.{name} = {name}\n')
    
            arguments.append(
                f'{name}: {annotation}'
                if default is None else
                f'{name}: {annotation} = {default}'
            )

            docstring.indent(
                (
                    f'\n{name} ({annotation}): '
                    if default is None
                    else f'\n{name} ({annotation}, optional): '
                )
                + (
                    parameter.get('@') or '...'
                )
            )

        description = tree.get('@')
        if description is not None:
            docstring.first(f'{description}\n\nArgs:')

            body.first(f'"""\n{docstring}\n"""\n\n')

        result.shaper(*arguments)

    return result.content.strip()

def create_to_bytes_function(tree: dict, module: 'utils.Module') -> builtins.str:
    result = utils.PyFormatter(
        '\ndef to_bytes(self, boxed: bool=True)'
    )

    object_id = tree['object_id']
    if object_id is not None:
        object_id = to_byte(object_id)

    def handel_type(type_data: dict, variable: str):
        args = [variable]

        if type_data['_'] == 'generic':
            is_type = (
                type_data['type'] == 'Type'
            )

            if type_data.get('modifier') == '!':
                is_type = not is_type

            if not is_type:
                module.add_import(
                    constants.BASE_FUNCTION_CLASS,
                    module=constants.BASE_CLASS_PATH
                )
                args.append(f'base_type={constants.BASE_FUNCTION_CLASS}')

        elif type_data['name'] != 'Object':
            boxed = not type_data['name'].islower()
            class_name = get_family_name(
                type_data['name'],
                type_data['namespace']
            )
            # If the object is bare, it should be referenced directly
            # Custom classes (that do not have an object_id) are also considered bare

            force_import = (
                not boxed
                or type_data.get('modifier') == '%'
            )

            if not boxed: # default True
                args.append(f'boxed={boxed}')

            if not force_import:
                args.append(f'group_id={to_hex(class_name)}')

            else:
                args.append(f'base_type={class_name}')
            
        result = utils.PyFormatter(f'writer.object')
        result.shaper(*args)

        return result.content.strip()

    def handel_vector(type_data: dict, variable: str):
        args = [variable]
        if type_data['type']['_'] == 'base_type':
            callback = 'writer.' + type_data['type']['name']
        
        else:
            callback = f'lambda value: {handel_type(type_data["type"], "value")}'

        args.append(callback.rstrip())

        if type_data['name'].islower():
            args.append('boxed=False')
        

        result = utils.PyFormatter('writer.vector')
        result.shaper(*args)
        return result.content.strip()

    with result.new(':', new_line=not tree['parameters']) as body:
        initial = f"{object_id} if boxed else b''"

        if tree['parameters']:
            module.add_import(
                constants.WRITER_CLASS,
                module=constants.BYTE_UTILS_PATH
            )
            if not object_id:
                initial = ''

            with body.new(f'with Writer({initial}) as writer:') as writer:

                for parameter in tree['parameters']:
                    name = utils.safe_name(parameter['name'])
        
                    type_data = parameter['type']
                    type_name = type_data['_']
    
 
                    # if parameter is flag (like: `flags:#`)
                    if type_name == 'flag':
                        if writer.level: # other flags
                            writer('\n')
                        writer(f'with writer.flag() as {name}:')
                        writer.level += 1 # new indent

                    elif type_name == 'base_type':
                        method = type_data['name']
                        writer(f'writer.{method}(self.{name})')
                    
                    # flagged type (like: is_bot:flags.1?true)
                    elif type_name == 'flagged_type':
                        flag_name = type_data['name']
                        flag_value = type_data['value']
                        
                        # more use (bare True == b'')
                        initial = f'{flag_name}(self.{name}, {flag_value})'
                        if type_data['type'].get('name') == 'true':
                            writer(initial, '\n')
                            continue

                        with writer.new(f'if {initial}:') as flagged:
                            type_name = type_data['type']['_']

                            if type_name == 'base_type':
                                method = type_data['type']['name']
                                flagged(f'writer.{method}(self.{name})') 

                            elif type_name == 'vector_type':
                                flagged(handel_vector(type_data['type'], f'self.{name}'))

                            else:
                                flagged(
                                    handel_type(
                                        type_data['type'],
                                        variable=f'self.{name}'
                                    )
                                )
                        
                        writer.trim_trailing_whitespace()

                    elif type_name == 'vector_type':
                        writer(handel_vector(type_data, f'self.{name}'))

                    else:
                        writer(handel_type(type_data, f'self.{name}'))

                    writer('\n')

                writer.level = 0
                writer('\nreturn writer.getvalue()')

        elif object_id:    
            body(f"return {object_id} if boxed else b''")

        else:
            body("return b''")

    return result.content.strip()

def create_from_reader_function(tree: dict, module: 'utils.Module'):
    result = utils.PyFormatter(
        '@classmethod\n'
        f'def from_reader(cls, reader: {constants.READER_CLASS!r})'
    )
    module.add_import(
        constants.READER_CLASS,
        module=constants.BYTE_UTILS_PATH,
        type_checking=True
    )

    def handel_type(type_data: dict):
        args = []
        if type_data['name'] != 'Object':
            class_name = get_family_name(
                type_data['name'],
                type_data['namespace']
            )
            # If the object is bare, it should be directly referenced
            # Custom classes (which do not have object_id) are also considered bare
            boxed = not type_data['name'].islower()
            force_import = (
                not boxed
                or type_data.get('modifier') == '%'
            )


            if not force_import:
                args.append(f'group_id={to_hex(class_name)}')

            else:
                args.append(f'boxed=False')
                args.append(f'base_type={class_name}')

        result = utils.PyFormatter(f'reader.object')
        result.shaper(*args)

        return result.content.strip()

    def handel_vector(type_data: dict):
        args = []
        if type_data['type']['_'] == 'base_type':
            callback = 'reader.' + type_data['type']['name']
        
        else:
            callback = f'lambda: {handel_type(type_data["type"])}'

        args.append(callback.rstrip())

        if type_data['name'].islower():
            args.append('boxed=False')
        
        result = utils.PyFormatter('reader.vector')
        result.shaper(*args)
        return result.content.strip()

    with result.new(':') as body:
        kwargs = {}

        if tree['parameters']:
            for parameter in tree['parameters']:
                name = utils.safe_name(parameter['name'])

                type_data = parameter['type']
                type_name = type_data['_']
  
                if type_name == 'flag':
                    body(f'{name} = reader.flag()')

                # base type
                elif type_name == 'base_type':
                    method = type_data['name']
                    body(f'{name}_ = reader.{method}()')

                # flagged type
                elif type_name == 'flagged_type':
                    flag_type = type_data['type']
                    flag_name = type_data['name']
                    flag_value = type_data['value']
                    
                    if flag_type.get('name') == 'true':
                        kwargs[name] = f'{flag_name}({flag_value})'
                        continue
                    
                    type_name = flag_type['_']
                    
                    if type_name == 'base_type':
                        method = flag_type['name']
                        reader = f'reader.{method}()'
                        
                    elif type_name == 'vector_type':
                        reader = handel_vector(flag_type)

                    else:
                        reader = handel_type(flag_type)

                    body(f'{name}_ = ')
                    body.shaper(reader.strip(), f'if {flag_name}({flag_value}) else None', separator='\n')

                elif type_name == 'vector_type':
                    body(f'{name}_ = {handel_vector(type_data)}\n')
        
                else:
                    body(f'{name}_ = {handel_type(type_data)}\n')
                
                body('\n')
                kwargs[name] = f'{name}_'


        arguments = []
        for parameter in filter(
            lambda param: param['type']['_'] != 'flag', # Exclude flags
            sorted(
                tree['parameters'],
                key=lambda param: param['type']['_'] == 'flagged_type' # Optional arguments come last
            )
        ):
            name = utils.safe_name(parameter['name'])

            arguments.append(f'{name}={kwargs[name]}')

        if arguments:
            body.trim_trailing_whitespace()
            body('\n\n')

        body('return cls')
        body.shaper(*arguments)

    return result.content.strip()


# converter
def type_language_converter(
    paths: t.Tuple[str, t.Optional[str], bool],  # [(ns1, path1, separate), ...],
    errors: t.Optional[dict] = None
):

    inits = {}
    modules = {}

    def get_or_create_module(path):
        result = inits.get(path)
        if result is None:
            result = modules.get(path)

        if result is None:
            result = utils.Module(path)

            if os.path.basename(path) == '__init__.py':
                inits[path] = result

            else:
                modules[path] = result

        return result
    
    for namespace, tl_path, separate in paths:
        is_type = True # reset
        main_init_path = os.path.join(namespace, '__init__.py')

        main_init = get_or_create_module(main_init_path)
        
        if separate:
            main_init.add_import('types', module='.')

        with open(tl_path, encoding='utf-8') as fp:
            content = fp.read()

        for data in parser.parse(content, name=tl_path):
            node_name = data.get('_')

            if node_name == 'object':
                path = get_file_path(
                    data,
                    is_type=is_type,
                    separate=separate,
                    namespace=namespace,
                )

                module = get_or_create_module(path)
                init_path = os.path.join(os.path.dirname(path), '__init__.py')

                # Generate the class code from the parsed data
                name, family, result = create_class(
                    data,
                    module=module,
                    errors=errors,
                    is_type=is_type,
                    separate=separate,
                    namespace=namespace
                )

                # __init__.py imports
                init = get_or_create_module(init_path)

                if is_type:
                    init.add_import(family, module=path)

                module.add_class(name, result)
                init.add_import(name, module=path)

            elif node_name == 'layer':
                main_init.add_variable('LAYER', value=str(data['value']))
            
            elif node_name == 'secret-chat-layer':
                main_init.add_variable(
                    'SECRET_CHAT_LAYER',
                    value=str(data['value'])
                )

            elif node_name == 'section':
                is_type = data['value'] == 'types'
                
                if separate:
                    main_init.add_import(
                        'types' if is_type else 'functions',
                        module='.'
                    )

    # Write all created modules to files
    for module in modules.values():
        module.write()

    # __init__.py
    for module in inits.values():
        base = os.path.dirname(module.path)

        # import namespaces
        for name in os.listdir(base):
            if (
                name.startswith('.')
                or name.startswith('_')
            ):
                continue

            if os.path.isdir(os.path.join(base, name)):
                module.add_import(name, module='.')

        module.write()

parser = TypeParser()

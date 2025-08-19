import os
import keyword
import typing as t
from textwrap import indent
from contextlib import contextmanager

from . import constants


class Module:
    def __repr__(self):
        return f'{self.__class__.__name__}({self.path!r})'

    def __init__(self, path: str):
        self.path = path
        self.classes = []
        self.imports = {}
        self.variables = {}


    def write(self):
        base = os.path.dirname(self.path)
        if not os.path.exists(base):
            os.makedirs(base)
        
        names = set()
        result = PyFormatter()        
        result.comment(constants.WARN_TEXT + '\n')
        type_checking_body = PyFormatter(level=1)

        def add_variables(current: int):
            names = set()
            nonlocal result
            for (level, name), value in self.variables.items():
                if current != level:
                    continue
                
                names.add(name)
                result(f'{name} = {value}\n')

            return names
        
        def sort_import_key(imp):
            module = imp[0][1]
            if module is None:
                return -1, len(imp[1])

            if not module.startswith('.'):
                return 0, len(imp[1])

            return len(module), len(imp[1])

        if add_variables(current=0):
            result('\n\n')

        for (type_checking, source), imps in sorted(
            self.imports.items(),
            key=sort_import_key
        ):
            if source is None:
                value = 'import '  
        
            else:
                value = f'from {source} import '

            value += ', '.join(imps) + '\n'

            if not type_checking:
                result(value) 

                # If `module` (source) has no value or the `module` level is greater than `.`,  
                # it does not belong to this namespace.
                if (
                    source is None
                    or not source.startswith('.')
                    or (
                        len(source) >= 2 
                        and source[1] == '.' # level >= 2
                    )
                ):
                    continue

                names.update(imps)
            
            else:
                type_checking_body(value)

        if self.imports:
            result('\n\n')
        
        if type_checking_body.content:
            result(f'if TYPE_CHECKING:\n{type_checking_body.content}\n\n')
        
        if add_variables(current=1):
            result('\n\n')
        
        for name, value in self.classes:
            names.add(name)
            result(f'{value}\n\n')

        others = add_variables(current=2)
        if self.path.endswith('__init__.py'):
            result.trim_trailing_whitespace()

            result('\n\n__all__ = ')
            result.shaper(
                *map(repr, names),
                *map(repr, others),
                open='[',
                close=']'
            )

        with open(self.path, 'w+', encoding='utf-8') as fp:
            fp.write(result.content.rstrip())

    def add_class(self, name: str, value: str):
        self.classes.append((name, value))

    def add_import(self, *imps, module: t.Optional[str] = None, type_checking: bool = False):
        """
        Adds an import to the module, supporting type-checking.

        Args:
            imps: Names of the imported items.
            module (str): The module path associated with the import.
            type_checking (bool): Whether the import should be included only for type checking.
        """
        if module != self.path:

            if module is not None:
                if os.path.sep in module:
                    module = get_module_path(self.path, module)

            key = (type_checking, module)
            if key not in self.imports:
                self.imports[key] = set()

            if type_checking:
                self.add_import('TYPE_CHECKING', module='typing')

            else:
                opposite = self.imports.get((True, module), set())
    
                for imp in imps:
                    if imp in opposite:
                        opposite.remove(imp)

                if not opposite:
                    self.imports.pop((True, module), None)

            self.imports[key].update(imps)

    def add_variable(self, name: str, value: str, level: int = 1):
        """
        Adds a variable to the module at a specific level.

        Args:
            name (str): The variable name.
            value (str): The variable value.
            level (int): The level of definition:
                - 0: Before imports.
                - 1: After imports.
                - 2: After class definitions.
        """
        self.variables[(level, name)] = str(value)

    def get_variable(self, name: str, level: int = 1):
        return self.variables.get((level, name), None)

class PyFormatter:
    def __repr__(self):
        return self.content

    def __init__(self, value: str = '', level: int = 0):
        self.level = level
        self.content = value

    def __call__(self, *args: str):
        """Appends a new string to the existing content."""
        prefix = ' ' * (constants.PY_INDENT * self.level)

        for item in args:
            for value in item.splitlines(True):
                if value != '\n' and (
                    not self.content
                    or self.content[-1] == '\n'
                ):
                    value = indent(value, prefix)

                self.content += value

    def first(self, *args: str):
        self.content = (
            ''.join(args)
            + self.content
        )

    def indent(self, value: str):
        self(indent(value, ' ' * constants.PY_INDENT))
    
    def comment(self, value: str):
        self(indent(value, '# '))

    @contextmanager
    def new(self, *args: str, new_line: bool=True):
        """
        Creates a new indented block of code.

        This method is a context manager that yields a new PyFormatter instance.
        When the context exits, the formatted block is added to the main content.

        """
        result = PyFormatter()
        yield result

        value = ''.join(args)
        if not value.startswith(':'):
            self.content += '\n'

        else:
            self.trim_trailing_whitespace()

        self(value)
        if result.content:
            if new_line:
                self.content += '\n'

            self.indent(result.content)
            self.content += '\n'

    def shaper(self,
               *args,
               open: str = '(',
               close: str = ')',
               separator: str = ',\n'):
        """
        Formats and appends multiple values with customizable delimiters.

        This method structures multiple values inside specified opening 
        and closing characters (e.g., parentheses, brackets) and separates 
        them using a defined separator.

        Args:
            *args (str): Values to be formatted.
            open (str, optional): Opening character for the formatted content. Defaults to '('.
            close (str, optional): Closing character for the formatted content. Defaults to ')'.
            separator (str, optional): Separator between values. Defaults to ',\\n'.

        """

        self.content += open
        if args:
            self.content += '\n'
            self.indent(separator.join(args))
            self.content += '\n'

        self.content += close
        self.content += '\n'

    def trim_trailing_whitespace(self):
        """
        Removes all trailing spaces and newline characters from the content.
        """
        self.content = self.content.rstrip()

def safe_name(value: str) -> str:
    """
    Generates a safe variable name based on the input.

    - If the input is 'self', it is prefixed with 'is_' to avoid reserved usage.
    - If the input is a Python keyword, an underscore ('_') is appended to make it a valid identifier.

    Example:
        >>> safe_name("class")
        'class_'
        >>> safe_name("self")
        'is_self'
    """

    if value in {'self'}:
        value = 'is_' + value

    if keyword.iskeyword(value):
        value += '_'

    return value

def title_case(value: str) -> str:
    """
    Converts a string to TitleCase.

    - Removes underscores and capitalizes each word.
    - Ensures words are split correctly at uppercase transitions or underscores.

    Example:
        >>> title_case("hello_world")
        'HelloWorld'
    """
    result = ''
    vision = True

    for char in value:
        if char == '_':
            vision = True

        elif vision:
            vision = False
            result += char.upper()

        else:
            result += char

    if keyword.iskeyword(result):
        result += '_'

    return result

def snake_case(value: str) -> str:
    """
    Converts a string to snake_case.

    - Inserts underscores before uppercase letters and converts the entire string to lowercase.
    - Replaces spaces with underscores.

    Example:
        >>> snake_case("HelloWorld")
        'hello_world'
    """
    result = ''
    for index, char in enumerate(value):
        if char.isupper():
            if index and value[index - 1].islower():
                result += '_'

            result += char.lower()
        else:
            result += char

    return result

def get_module_path(path: str, target_path: str) -> str:
    """
    Determines the module import path relative to a given base path.

    This function calculates the appropriate import path by finding the 
    relative difference between the base path and the target module path.

    Args:
        path (str): file path.
        target_path (str): The target module path.

    Example:
        >>> get_module_path("project/app/module.py", "project/app/utils/helpers.py")
        '.utils.helpers'
    """
    if os.path.sep not in target_path:
        return target_path

    common = os.path.commonpath([path, target_path])

    path = path.replace(common, '')
    target_path = target_path.replace(common, '')
    

    result = ''
    for p1 in path.split(os.path.sep):
        if p1:
            result += '.'

    for p2 in target_path.split(os.path.sep):
        if p2:
            name, _ = os.path.splitext(p2)

            if name == '__init__':
                continue

            if not result.endswith('.'):
                result += '.'

            result += name
    return str(result)

# -*- coding: utf-8 -*-

import os
import sys
import time
import argparse
import threading
import subprocess
import typing as t
from itertools import cycle
from datetime import timedelta
from contextlib import contextmanager

from builder import (
    clean,
    pkg_path,
    generate_code,
    ROOT, TL_FOLDER, ERRORS_FOLDER
)

def run(*args: str) -> None:
    subprocess.check_call(list(args), cwd=ROOT)

def prompt(question: str, default: bool = False) -> bool:
    yes_no = 'Y/n' if default else 'y/N'
    answer = input(f'{question} [{yes_no}] ').strip()
    if not answer:
        return default

    return answer.lower() == 'y'

def seconds_to_hms(seconds: t.Union[int, float]):
    return str(timedelta(seconds=int(seconds)))

def is_empty_folder(path: str) -> bool:
    return not os.path.exists(path) or not os.listdir(path)


@contextmanager
def spinner(message, delay=.1):
    stop_thread = False

    def worker():
        chars = cycle('|/-\\')
        start_time = time.time()

        while not stop_thread:
            elapsed = seconds_to_hms(time.time() - start_time)

            sys.stdout.write(f'\r{message} {next(chars)} [{elapsed}]')
            sys.stdout.flush()
            time.sleep(delay)

        GREEN = '\033[32m'
        RESET = '\033[0m'
        elapsed = seconds_to_hms(time.time() - start_time)
        sys.stdout.write(f'\r{message} {GREEN}Done{RESET} [{elapsed}]\n')

    thread = threading.Thread(target=worker)
    thread.start()

    try:
        yield

    finally:
        stop_thread = True
        thread.join()


def get_version() -> str:
    variables = {}
    with open(pkg_path('about.py'), encoding='utf-8') as fp:
        exec(fp.read(), {}, variables)
    
    return variables['__version__']


if __name__ == '__main__':
    version = get_version()
    packman = argparse.ArgumentParser(
        description=f'Package manager (v: {version})'
    )

    command = packman.add_subparsers(
        dest='command'
    )

    # clean --force
    # generate --force
    commands = [
        ('clean', 'clean generated files'),
        ('generate', 'generate tl and errors'),
        ('release', f'create and push git tag ( v{version} )')
    ]
    for name, help_text in commands:
        parser = command.add_parser(
            name,
            help=help_text
        )
        parser.add_argument(
            '--force',
            action='store_true',
            help='run without prompt'
        )

    args = packman.parse_args()

    if args.command == 'clean':
        if not args.force:

            confirm = prompt(f'Are you sure you want to clean ?')
            if not confirm:
                sys.exit(0)

        with spinner(f'Cleaning ...'):
            clean()

    elif args.command == 'generate':
        if not args.force:
            existing = []

            if not is_empty_folder(TL_FOLDER):
                existing.append('TL')
    
            if not is_empty_folder(ERRORS_FOLDER):
                existing.append('Errors')

            if existing:
                folders = ' and '.join(existing)
                
                confirm = prompt(
                    f'The {folders} folder(s) already exist. '
                    'Do you want to continue?'
                )
                if not confirm:
                    sys.exit(0)

        with spinner('Generating ...'):
            generate_code()

    elif args.command == 'release':
        tag_name = f'v{version}'
        with spinner(f"Creating release tag {tag_name} ..."):
            run('git', 'tag', '-a', tag_name, '-m', f'{tag_name} release')

        if not args.force:
            confirm = prompt(f'Push tag {tag_name} to remote?')
            if not confirm:
                sys.exit(0)
        
        with spinner(f'Pushing tag {tag_name} ...'):
            run('git', 'push', 'origin', tag_name)

    else:
        packman.print_help()
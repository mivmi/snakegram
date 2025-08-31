import sys
import subprocess
from setuptools import setup
from setuptools.command.build_py import build_py



class Generate(build_py):    
    def run(self):
        print('Running build-py hook: generating code...')
        command = [
            sys.executable,
            'packman.py', 'generate', '--force'
        ]
        subprocess.run(command, check=True)
        return super().run()

setup(
    cmdclass={
        'build_py': Generate
    }
)

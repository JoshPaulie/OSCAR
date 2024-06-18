from setuptools import setup

from OSCAR import version

APP = ["OSCAR.py"]
DATA_FILES = []
OPTIONS = {
    "argv_emulation": True,
    "plist": {
        "LSUIElement": True,
    },
    "packages": ["rumps"],
}

setup(
    app=APP,
    data_files=DATA_FILES,
    options={"py2app": OPTIONS},
    setup_requires=["py2app"],
    name="OSCAR",
    version=version,
)

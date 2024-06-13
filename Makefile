.PHONY: all build setup run

# Default target
all: setup run

# Build target to build Py2App
build:
	rm -fr build dist
	python setup.py py2app
    # Ditto is required to bundle the .app before uploading to github releases
	ditto -c -k --sequesterRsrc --keepParent dist/OSCAR.app dist/OSCAR.zip

# Setup target to create virtual environment and install dependencies
setup:
	python -m venv .venv
	.venv/bin/pip install -r requirements.txt

# Run target to execute the main Python script
run:
	.venv/bin/python OSCAR.py

.PHONY: all setup run clean

# Default target
all: setup run

# Build target to build Py2App
build:
	python setup.py py2app

# Setup target to create virtual environment and install dependencies
setup:
	python -m venv .venv
	.venv/bin/pip install -r requirements.txt

# Run target to execute the main Python script
run:
	.venv/bin/python OSCAR.py

# Clean target to remove the virtual environment
clean:
	rm -rf .venv dist build

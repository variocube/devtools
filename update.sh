#!/usr/bin/env bash

if [ ! -d .devtools ]; then
	echo "Error: Could not find .devtools directory."
	echo "This script is designed to be run from the project root."
	exit 1
fi

git submodule update --init --remote
git add .devtools
git commit -m "chore: upgrade devtools"



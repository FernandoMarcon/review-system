#!/bin/bash

# A script to find Markdown files modified yesterday.

# Directory to search in. Defaults to the current directory "." if no argument is provided.
# SEARCH_DIR="${1:-.}"
SEARCH_DIR="${HOME}/Vault"

echo "Searching for Markdown files (.md, .markdown) in '$SEARCH_DIR' modified yesterday..."

# find: the command to search for files
# $SEARCH_DIR: the directory to start the search from
# -type f: only look for files
# \( -iname "*.md" -o -iname "*.markdown" \): find files with names ending in .md or .markdown (case-insensitive)
# -newermt "yesterday": find files modified at or after the start of yesterday
# -not -newermt "today": exclude files modified at or after the start of today
find "$SEARCH_DIR" -type f \( -iname "*.md" -o -iname "*.markdown" \) -newermt "yesterday" -not -newermt "today"

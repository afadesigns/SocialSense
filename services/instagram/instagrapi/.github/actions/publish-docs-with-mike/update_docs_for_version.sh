#!/usr/bin/env bash

# Check if the number of arguments is correct
if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 <new_version>"
    exit 1
fi

# Check if the mike command is installed
if ! command -v mike &> /dev/null; then
    echo "Error: mike command not found in PATH"
    exit 1
fi

# Check if the jq command is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq command not found in PATH"
    exit 1
fi

# Get the previous latest version number
PREV_LATEST="$(mike list --json | jq --raw-output '.[] | select(.aliases == ["latest"]) | .version')"

# Check if a previous latest version number was found
if [[ "${PREV_LATEST}" == "" ]]; then
    echo "No previous version found using the latest alias. Nothing to retitle."
else
    # Check if the previous latest version number is not equal to the new version number
    if [[ "${PREV_LATEST}" == "${1}" ]]; then
        echo "Error: The new version number cannot be the same as the previous latest version number."
        exit 1
    fi

    # Retitle the previous latest version number
    echo "Retitling previous latest version ${PREV_LATEST}..."
    if ! m

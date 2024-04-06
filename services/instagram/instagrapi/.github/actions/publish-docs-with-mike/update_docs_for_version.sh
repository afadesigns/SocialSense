#!/usr/bin/env bash

set -eo pipefail

# Check if mike command is installed
if ! command -v mike &> /dev/null
then
    echo "Error: mike command not found"
    exit 1
fi

# Check if jq command is installed
if ! command -v jq &> /dev/null
then
    echo "Error: jq command not found"
    exit 1
fi

# Check if NEW_VERSION variable is empty
if [ -z "${1}" ]
then
    echo "Usage: $(basename "${0}") <new_version>"
    exit 1
fi

NEW_VERSION="${1}"
PREV_LATEST="$(mike list --input-format json --input-alias latest --output-format json | jq

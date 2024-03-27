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

NEW_VERSION="${1}"
if [[ -z "${NEW_VERSION}" ]]; then
    echo "Usage: $(basename ${0}) <new_version>"
    echo "Retitles the previous latest version and deploys a new version with the 'latest' alias."
    exit 1
fi

PREV_LATEST="$(mike list --json | jq --raw-output '.[] | select(.aliases == ["latest"]) | .version')"

if [[ "${PREV_LATEST}" == "" ]]; then
    echo "No previous version found using the latest alias. Nothing to retitle."
else
    if [[ "${PREV_LATEST}" == "${NEW_VERSION}" ]]; then
        echo "Error: The new version cannot be the same as the previous latest version."
        exit

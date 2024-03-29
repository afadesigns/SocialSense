#!/usr/bin/env bash

set -eo pipefail

# Check if the user provided a new version number
if [[ "${1}" == "" ]]; then
  echo "Usage: $(basename "${0}") <new_version>"
  exit 1
fi

NEW_VERSION="${1}"
MIKE_CMD="mike"
JQ_CMD="jq"

# Check if mike command is installed
if ! command -v "${MIKE_CMD}" &> /dev/null; then
  echo "Error: mike command not found in system's PATH."
  exit 1
fi

# Check if jq command is installed
if ! command -v "${JQ_CMD}" &> /dev/null; then
  echo "Error: jq command not found in system's PATH."
  exit 1
fi

PREV_LATEST="$(mike list --json | "${JQ_CMD}" --raw-output '.[] | select(.aliases == ["latest"]) | .version')"

if [[ "${PREV_LATEST}" == "" ]]; then
  echo "No previous version found using the latest alias. Nothing to retitle."
else
  # Prevent accidental modification of the previous version's title
  echo "mike retitle --dry-run --message \"

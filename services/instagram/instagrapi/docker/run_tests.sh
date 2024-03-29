#!/usr/bin/env bash

set -eo pipefail

BLACK_ACTION="--check"
ISORT_ACTION="--check-only"
FORMAT_CODE=false

function usage() {
    echo "usage: run_tests.sh [-f|--format-code] [-h|--help]"
    echo ""
    echo "-f, --format-code : Format the code instead of checking formatting."
    echo "-h, --help : Display this help message."
    exit 1
}

while [[ $# -gt 0 ]]; do
    arg="$1"
    case $arg in
        -f|--format-code)
        FORMAT_CODE=true
        BLACK_ACTION="--quiet"
        ISORT_ACTION="--recursive"
        ;;
        -h|--help)
        usage
        ;;
        "")
        # ignore
        ;;
        *)
        echo "Unexpected argument: ${arg}"
        usage
        ;;
    esac
    shift
done

python -m unittest tests.FakeClientTestCase tests.ClientPublicTestCase

if $FORMAT_CODE; then
    echo "Formatting code..."
    black ${BLACK_ACTION} instagrapi
    isort ${ISORT_ACTION} instagrapi
else
    echo "Checking code formatting..."
    black ${BLACK_ACTION} instagrapi || { echo "Black failed. Please format the code."; exit 1; }
    isort ${ISORT_ACTION} instagrapi || { echo "Isort failed. Please format the code."; exit 1; }
fi

echo "Running flake8..."
flake8 instagrapi --count --exit-zero --statistics

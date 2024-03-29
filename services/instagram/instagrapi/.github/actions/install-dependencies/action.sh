#!/bin/bash

set -euo pipefail

echo "Ensuring pip is up to date"
python3 -m pip install --upgrade pip

if [[ "${INSTALL_REQUIREMENTS:-false}" == "true" ]]; then
  echo "Installing code requirements"
  pip3 install -r requirements.txt
fi

if [[ "${INSTALL_TEST_REQUIREMENTS:-false}" == "true" ]]; then
  echo "Installing test requirements"
  pip3 install -r requirements-test.txt
fi

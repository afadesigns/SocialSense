#!/usr/bin/env bash

set -euo pipefail

NO_REPLY_SUFFIX="@users.noreply.github.com"

function set_and_exit() {
  local name="${1:-${GITHUB_ACTOR}}"
  local email="${2:-"${name}${NO_REPLY_SUFFIX}"}"
  git config --local user.name "${name}"
  git config --local user.email "${email}"
  exit 0
}

function json_query() {
  jq -e "${1}" "${GITHUB_EVENT_PATH}"
}

function get_user_info() {
  if json_query ".push.pusher" > /dev/null ; then
    echo "::debug::Found push event pusher"
    json_query '.push.pusher | {name, email}'
  elif json_query ".pull_request.merged_by" > /dev/null ; then
    echo "::debug::Found pull request event merged by"
    json_query '.pull_request.merged_by | {login: .login, email: .login + "'"${NO_REPLY_SUFFIX}"'"} '
  elif json_query ".sender" > /dev/null ; then
    echo "::debug::Found pull event sender"
    json_query '.sender | {login: .login, email: .login + "'"${NO_REPLY_SUFFIX}"'"} '
  else
    echo "::debug::Falling back to GITHUB_ACTOR"
    echo "{\"name\": \"${GITHUB_ACTOR}\", \"email\": \"${GITHUB_ACTOR}${NO_REPLY_SUFFIX}\"}"
  fi
}

if [[ "${USER_NAME}" != "" && "${USER_EMAIL}" != "" ]]; then
  set_and_exit "${USER_NAME}" "${USER_EMAIL}"
fi

get_user_info | jq -r 'to_entries | .[] | {name: .key, email: .value} | [.name, .email] |

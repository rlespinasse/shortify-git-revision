#!/usr/bin/env bash

if [[ "$OSTYPE" == "darwin"* ]]; then
  # On MacOS,
  # bash don't support substitution, so we use 'tr'
  NAME=$(echo "$INPUT_NAME" | tr '[:lower:]' '[:upper:]')
else
  NAME=${INPUT_NAME^^}
fi
REVISION=${INPUT_REVISION:-${!NAME}}

if [ -z "$REVISION" ]; then
  exit 0
fi

if [ "$(git cat-file -e "$REVISION")" == "" ]; then
  {
    echo "${NAME}=${REVISION}"
    echo "${NAME}_SHORT=$(git rev-parse --short "$REVISION")"
  } >>"$GITHUB_ENV"
fi

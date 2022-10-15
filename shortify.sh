#!/usr/bin/env bash

if [[ "$OSTYPE" == "darwin"* ]]; then
  # On MacOS,
  # bash don't support substitution, so we use 'tr'
  NAME=$(echo "$INPUT_NAME" | tr '[:lower:]' '[:upper:]')
  PREFIX=$(echo "$INPUT_PREFIX" | tr '[:lower:]' '[:upper:]')
else
  NAME=${INPUT_NAME^^}
  PREFIX=${INPUT_PREFIX^^}
fi
REVISION=${INPUT_REVISION:-${!NAME}}

SHORT_LENGTH=""
if [ "${INPUT_LENGTH}" != "" ]; then
  if [ "${INPUT_LENGTH}" -eq "${INPUT_LENGTH}" ] 2>/dev/null; then
    SHORT_LENGTH="=${INPUT_LENGTH}"
  elif [ "${INPUT_CONTINUE_ON_ERROR}" == "false" ]; then
    echo "::error ::Invalid length: ${INPUT_LENGTH}, should be a number"
    exit 1
  else
    echo "::warning ::Invalid length: ${INPUT_LENGTH}, the default length will be used."
  fi
fi

if [ -z "${REVISION}" ]; then
  exit 0
fi

SHORT_PUBLICATION=false
if [ "$(git cat-file -e "${REVISION}" 2>&1)" == "" ]; then
  SHORT_VALUE=$(git rev-parse --short"${SHORT_LENGTH}" "${REVISION}")
  SHORT_PUBLICATION="true"
elif [ "${INPUT_SHORT_ON_ERROR}" == "true" ]; then
  if [ -n "${INPUT_LENGTH}" ]; then
    SHORT_VALUE=$(cut -c1-"${INPUT_LENGTH}" <<<"${REVISION}")
    SHORT_PUBLICATION="true"
  else
    echo "::error ::The input 'length' is mandatory with 'short-on-error' set to 'true'"
    exit 1
  fi
elif [ "${INPUT_CONTINUE_ON_ERROR}" == "false" ]; then
  echo "::error ::Invalid revision: ${REVISION} from ${NAME}"
  exit 1
fi

if [ "${SHORT_PUBLICATION}" == "true" ]; then
  echo "revision=${REVISION}" >> "$GITHUB_OUTPUT"
  echo "short=${SHORT_VALUE}" >> "$GITHUB_OUTPUT"

  if [ "${INPUT_PUBLISH_ENV}" == "true" ]; then
    {
      echo "${PREFIX}${NAME}=${REVISION}"
      echo "${PREFIX}${NAME}_SHORT=${SHORT_VALUE}"
    } >>"$GITHUB_ENV"
  fi
fi

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

if [ "$(git cat-file -e "${REVISION}" 2>&1)" == "" ]; then
  {
    echo "${PREFIX}${NAME}=${REVISION}"
    echo "${PREFIX}${NAME}_SHORT=$(git rev-parse --short"${SHORT_LENGTH}" "${REVISION}")"
  } >>"$GITHUB_ENV"
elif [ "${INPUT_SHORT_ON_ERROR}" == "true" ]; then
  if [ -n "${INPUT_LENGTH}" ]; then
    {
      echo "${PREFIX}${NAME}=${REVISION}"
      echo "${PREFIX}${NAME}_SHORT=$(cut -c1-"${INPUT_LENGTH}" <<<"${REVISION}")"
    } >>"$GITHUB_ENV"
  else
    echo "::error ::The input 'lenght' is mandatory with 'short-on-error' set to 'true'"
    exit 1
  fi
elif [ "${INPUT_CONTINUE_ON_ERROR}" == "false" ]; then
  echo "::error ::Invalid revision: ${REVISION} from ${NAME}"
  exit 1
fi

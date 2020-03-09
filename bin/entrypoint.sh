#!/usr/bin/env bash
set -e

main() {
   if [[ "${INPUT_DRY_RUN}" == "true" ]]; then
      cargo release "${INPUT_VERSION}" --dry-run --no-dev-version
   fi

   if [[ "${INPUT_DRY_RUN}" == "false" ]]; then
      cargo release "${INPUT_VERSION}" --no-dev-version
   fi
}

main

#!/usr/bin/env sh
set -e

function main() {
   cargo release "${INPUT_VERSION}" --dry-run --no-dev-version
}

main
#!/usr/bin/env bash
set -e

main() {
   cargo release "${INPUT_VERSION}" --dry-run --no-dev-version
}

main
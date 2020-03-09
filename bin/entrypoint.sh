#!/usr/bin/env bash
set -eu
declare REMOTE="${REMOTE:-cargo}"
declare GITHUB_TOKEN="${GITHUB_TOKEN:-}"
declare GITHUB_ACTOR="${GITHUB_ACTOR:-}"
declare GITHUB_REPOSITORY="${GITHUB_REPOSITORY:-}"
declare INPUT_DRY_RUN="${INPUT_DRY_RUN:-false}"
declare INPUT_VERSION="${INPUT_VERSION:-}"

main() {
   # check to see if we have a GITHUB_TOKEN set other exit
   is_a_token_set

   # initialize git settings for pushing tags and updated manifests
   setup_git

   if [[ "${INPUT_DRY_RUN}" == "true" ]]; then
      cargo release "${INPUT_VERSION}" --dry-run --no-dev-version --push-remote "${REMOTE}"
   fi

   if [[ "${INPUT_DRY_RUN}" == "false" ]]; then
      cargo release "${INPUT_VERSION}" --no-dev-version --push-remote "${REMOTE}"
   fi
}

is_a_token_set() {
   if [[ -z "${GITHUB_TOKEN:-}" ]]; then
    echo "No GITHUB_TOKEN set"
    exit 1
   fi
}

setup_git() {
   local remote_repo="https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
   git config http.sslVerify false
   git config user.name "Automated Publisher"
   git config user.email "actions@users.noreply.github.com"
   git remote add "${REMOTE}" "${remote_repo}"
   git show-ref # useful for debugging
}

main

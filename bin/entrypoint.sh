#!/usr/bin/env bash
set -eu
declare INPUT_REMOTE="${INPUT_REMOTE:-origin}"
declare INPUT_TOKEN="${INPUT_TOKEN:-}"
declare GITHUB_ACTOR="${GITHUB_ACTOR:-}"
declare GITHUB_REPOSITORY="${GITHUB_REPOSITORY:-}"
declare INPUT_DRY_RUN="${INPUT_DRY_RUN:-false}"
declare INPUT_VERSION="${INPUT_VERSION:-}"
declare INPUT_USER="${INPUT_USER:-Automated User}"
declare INPUT_EMAIL="${INPUT_USER:-actions@users.noreply.github.com}"

main() {
   # check to see if we have a INPUT_TOKEN set other exit
   is_a_token_set

   # initialize git settings for pushing tags and updated manifests
   setup_git

   if [[ "${INPUT_DRY_RUN}" == "true" ]]; then
      cargo release "${INPUT_VERSION}" --dry-run --no-dev-version --push-remote "${INPUT_REMOTE}"
   fi

   if [[ "${INPUT_DRY_RUN}" == "false" ]]; then
      cargo release "${INPUT_VERSION}" --no-dev-version --no-confirm --push-remote "${INPUT_REMOTE}"
   fi
}

is_a_token_set() {
   if [[ -z "${INPUT_TOKEN:-}" ]]; then
      echo "No INPUT_TOKEN set"
      exit 1
   fi
}

setup_git() {
   local remote_repo="https://${GITHUB_ACTOR}:${INPUT_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
   git config user.name "${INPUT_USER}"
   git config user.email "${INPUT_EMAIL}"
   git remote set-url "${INPUT_REMOTE}" "${remote_repo}"
   git show-ref # useful for debugging
}

main

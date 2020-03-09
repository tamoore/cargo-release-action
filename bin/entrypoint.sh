#!/usr/bin/env bash
set -eu
declare INPUT_REMOTE="${INPUT_REMOTE:-origin}"
declare INPUT_TOKEN="${INPUT_TOKEN:-}"
declare GITHUB_TOKEN="${GITHUB_TOKEN:-}"
declare GITHUB_ACTOR="${GITHUB_ACTOR:-}"
declare GITHUB_REPOSITORY="${GITHUB_REPOSITORY:-}"
declare INPUT_DRY_RUN="${INPUT_DRY_RUN:-false}"
declare INPUT_VERSION="${INPUT_VERSION:-}"
declare INPUT_USER="${INPUT_USER:-Automated User}"
declare INPUT_EMAIL="${INPUT_USER:-actions@users.noreply.github.com}"

main() {
   sanitize "${GITHUB_TOKEN}" "env var GITHUB_TOKEN is required"

   # initialize git settings for pushing tags and updated manifests
   setup_git

   if [[ "${INPUT_DRY_RUN}" == "true" ]]; then
      cargo release "${INPUT_VERSION}" --dry-run --no-dev-version --push-remote "${INPUT_REMOTE}"
   fi

   if [[ "${INPUT_DRY_RUN}" == "false" ]]; then
      cargo release "${INPUT_VERSION}" --no-dev-version --no-confirm --push-remote "${INPUT_REMOTE}"
   fi
}

sanitize() {
   if [[ -z "${1}" ]]; then
      echo >&2 "Unable to find the ${2}. Did you set with.${2}?"
      exit 1
   fi
}

setup_git() {
   local remote_repo="https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
   git config user.name "${INPUT_USER}"
   git config user.email "${INPUT_EMAIL}"
   git remote set-url "${INPUT_REMOTE}" "${remote_repo}"
   git remote -v show

}

main

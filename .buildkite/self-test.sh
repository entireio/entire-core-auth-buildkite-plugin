#!/usr/bin/env bash
# Runs AFTER the plugin's environment hook. Asserts the hook's two
# observable effects; the hook itself already failed the job if the
# OIDC mint or token exchange did.
set -euo pipefail

echo "--- ENTIRE_TOKEN exported"
[[ -n "${ENTIRE_TOKEN:-}" ]] || { echo "ENTIRE_TOKEN is empty/unset" >&2; exit 1; }

echo "--- ENTIRE_CORE_AUTH_BASE_URL matches plugin url"
[[ "${ENTIRE_CORE_AUTH_BASE_URL:-}" == "${ENTIRE_CORE_AUTH_URL%/}" ]] || {
  echo "ENTIRE_CORE_AUTH_BASE_URL=${ENTIRE_CORE_AUTH_BASE_URL:-<unset>} != ${ENTIRE_CORE_AUTH_URL%/}" >&2
  exit 1
}

echo "--- git-remote-entire on PATH"
command -v git-remote-entire

# Optional full round trip: prove the minted token is accepted by the
# deployment, not just issued. Set ENTIRE_SELF_TEST_REPO (pipeline env)
# to an entire:// URL the service account can read.
if [[ -n "${ENTIRE_SELF_TEST_REPO:-}" ]]; then
  echo "--- git ls-remote ${ENTIRE_SELF_TEST_REPO}"
  git ls-remote "${ENTIRE_SELF_TEST_REPO}" HEAD
else
  echo "--- skipping ls-remote round trip (ENTIRE_SELF_TEST_REPO not set)"
fi

echo "+++ :white_check_mark: plugin self-test passed"

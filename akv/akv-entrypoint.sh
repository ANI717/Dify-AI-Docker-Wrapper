#!/usr/bin/env sh
set -e

# Optional: allow overriding output path
: "${AKV_ENV_FILE:=/tmp/akv.env}"

# Run the Python fetcher; do not fail hard if no secrets are defined.
if [ -n "${VAULT_URL}${AZURE_KEY_VAULT_URL}${SECRET_NAMES}" ]; then
  python3 /akv_bootstrap.py || echo "AKV bootstrap failed (continuing)..."
  if [ -f "$AKV_ENV_FILE" ]; then
    # Export all variables from the generated file
    # shellcheck source=/dev/null
    set -a
    . "$AKV_ENV_FILE"
    set +a
  fi
fi

# Chain to the original CMD passed by the base image
exec "$@"

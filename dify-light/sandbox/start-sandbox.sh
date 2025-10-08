#!/usr/bin/env bash
set -euo pipefail

# ensure /temp structure whenever the container starts
mkdir -p /temp /temp/dependencies
chmod -R 777 /temp
[ -e /dependencies ] || ln -s /temp/dependencies /dependencies

# If the image already has the correct entrypoint/CMD, prefer it.
# Try common binary locations as fallback to avoid guessing wrong.
if command -v dify-sandbox >/dev/null 2>&1; then
  exec dify-sandbox
elif [ -x /main ]; then
  exec /main
elif [ -x /app/main ]; then
  exec /app/main
else
  echo "ERROR: sandbox binary not found. Check image tag." >&2
  sleep infinity
fi

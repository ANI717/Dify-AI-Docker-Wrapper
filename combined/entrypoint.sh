#!/usr/bin/env bash
set -euo pipefail

# Load .env if present
if [ -f "/app/.env" ]; then
  set -a
  . /app/.env
  set +a
fi

echo "[entrypoint] PATH=$PATH"
echo "[entrypoint] PORT_WEB=${PORT_WEB:-unset} PORT_API=${PORT_API:-unset}"

# Start supervisor in foreground
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf

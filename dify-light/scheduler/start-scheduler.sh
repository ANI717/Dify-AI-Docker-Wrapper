#!/usr/bin/env bash
set -euo pipefail

# Ensure writable dirs
mkdir -p /temp /temp/logs /temp/cache

# Minimal health endpoint
python /opt/health/health_server.py --port "${HEALTH_PORT:-8080}" &

# Celery beat (persistent state into /temp)
exec celery -A app.celery beat \
  --loglevel "${CELERY_LOG_LEVEL:-INFO}" \
  --pidfile "/temp/celerybeat.pid" \
  --schedule "/temp/celerybeat-schedule"

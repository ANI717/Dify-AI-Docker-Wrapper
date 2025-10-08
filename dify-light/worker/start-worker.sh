#!/usr/bin/env bash
set -euo pipefail

mkdir -p /temp /temp/storage /temp/logs /temp/uploads /temp/cache

# Minimal external health endpoint
python /opt/health/health_server.py --port "${HEALTH_PORT:-8080}" &

# Dify Celery worker (documented queues)
exec celery -A app.celery worker \
  -P gevent \
  -c "${CELERY_WORKER_AMOUNT:-1}" \
  --loglevel "${CELERY_LOG_LEVEL:-INFO}" \
  -Q dataset,generation,mail,ops_trace

#!/bin/sh
set -e

# Env-configurable knobs (from .env or -e flags)
PORT="${REDIS_PORT:-6379}"
PASS="${REDIS_PASSWORD:-}"          # optional; if empty, no auth
APPENDONLY="${REDIS_APPENDONLY:-yes}"
MAXMEMORY="${REDIS_MAXMEMORY:-}"    # e.g., "256mb" (optional)
MAXMEMORY_POLICY="${REDIS_MAXMEMORY_POLICY:-noeviction}"  # optional

# data dir (no volume declared; mount host dir if you want persistence)
DATA_DIR="/data"
mkdir -p "$DATA_DIR"

# Build a minimal redis.conf from env
cat >/tmp/redis.conf <<EOF
port ${PORT}
bind 0.0.0.0
protected-mode no
dir ${DATA_DIR}
appendonly ${APPENDONLY}
EOF

# Optional settings only if provided
if [ -n "$PASS" ]; then
  echo "requirepass ${PASS}" >> /tmp/redis.conf
fi
if [ -n "$MAXMEMORY" ]; then
  echo "maxmemory ${MAXMEMORY}" >> /tmp/redis.conf
  echo "maxmemory-policy ${MAXMEMORY_POLICY}" >> /tmp/redis.conf
fi

exec redis-server /tmp/redis.conf

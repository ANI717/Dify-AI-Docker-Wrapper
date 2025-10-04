# Python + Node + Supervisor in one image
FROM python:3.11-slim

# Pin the Dify repo version (tag or branch). For 1.9.1, use "1.9.1" (no "v").
ARG DIFY_VERSION=1.9.1

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
  PIP_NO_CACHE_DIR=1 \
  NODE_ENV=production \
  PORT_WEB=8080 \
  PORT_API=5001 \
  LOG_LEVEL=INFO

WORKDIR /app

# OS deps
RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential gcc libpq-dev supervisor curl ca-certificates bash git file gnupg \
 && rm -rf /var/lib/apt/lists/*

# Install Node 18 (matches typical Dify web expectations)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
 && apt-get update && apt-get install -y --no-install-recommends nodejs \
 && rm -rf /var/lib/apt/lists/*

# Enable pnpm via corepack (bundled with Node 18+)
RUN corepack enable && corepack prepare pnpm@9 --activate

# --- Clone Dify repo ---
RUN git clone --depth=1 --branch ${DIFY_VERSION} https://github.com/langgenius/dify.git /app/src

# --- Python deps (API) ---
RUN python -m venv /app/api/.venv \
 && /app/api/.venv/bin/python -m pip install --upgrade pip setuptools wheel \
 && cd /app/src/api && /app/api/.venv/bin/pip install . \
 && /app/api/.venv/bin/pip install gunicorn celery

# --- Node deps + build (Web) ---
# Prefer pnpm if lockfile is present, otherwise fall back to npm.
RUN cd /app/src/web \
 && if [ -f pnpm-lock.yaml ]; then \
      pnpm install --frozen-lockfile && pnpm build; \
    elif [ -f package-lock.json ]; then \
      npm ci && npm run build; \
    else \
      npm pkg set overrides.react="^18.3.1" overrides.react-dom="^18.3.1" \
      && npm install --legacy-peer-deps \
      && npm run build; \
    fi

# Put venv on PATH for supervisor children
ENV PATH="/app/api/.venv/bin:${PATH}"

# Our supervisor config + entrypoint
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && mkdir -p /var/log

EXPOSE 8080 5001
CMD ["/entrypoint.sh"]

# --- Build stage ---
FROM node:20-alpine AS builder

# system deps for building and git clone
RUN apk add --no-cache git python3 make g++ libc6-compat

# enable pnpm via corepack
RUN corepack enable && corepack prepare pnpm@9.0.0 --activate

WORKDIR /src

# 1) Clone Dify (UI lives under /web). Shallow clone to keep image small.
RUN git clone --depth=1 https://github.com/langgenius/dify.git

# 2) Install and build the Console (Next.js) app
WORKDIR /src/dify/web
RUN pnpm install --frozen-lockfile || pnpm install
RUN pnpm build

# --- Runtime stage ---
FROM node:20-alpine AS runtime

# Create an unprivileged user and the only writable dir: /temp
ARG APP_USER=app
RUN addgroup -g 10001 -S ${APP_USER} && adduser -S -D -H -u 10001 -G ${APP_USER} ${APP_USER}
RUN mkdir -p /temp && chown -R ${APP_USER}:${APP_USER} /temp

# App directory (read-only at runtime; we will run container with --read-only)
WORKDIR /opt/app

# Copy built UI and node_modules from builder
COPY --from=builder /src/dify/web/.next ./.next
COPY --from=builder /src/dify/web/node_modules ./node_modules
COPY --from=builder /src/dify/web/public ./public
COPY --from=builder /src/dify/web/package.json ./package.json

# --- Environment defaults (overridable by --env-file .env) ---
ENV REDIS_URL="redis://host.docker.internal:6379/0" \
    DATABASE_URL="postgresql://dify:dify@localhost:5432/dify" \
    QDRANT_URL="http://host.docker.internal:6334" \
    SANDBOX_SERVICE_URL="http://host.docker.internal:8194" \
    APP_API_URL="http://host.docker.internal:5001" \
    CONSOLE_API_URL="http://host.docker.internal:5001" \
    PORT="8080" \
    TMPDIR="/temp" \
    XDG_CACHE_HOME="/temp/.cache" \
    HOME="/temp" \
    NODE_ENV="production" \
    NEXT_TELEMETRY_DISABLED="1"

EXPOSE 8080

# Drop privileges
USER 10001:10001

# Serve the built Next.js app
CMD ["node", "node_modules/next/dist/bin/next", "start", "-p", "8080", "-H", "0.0.0.0"]

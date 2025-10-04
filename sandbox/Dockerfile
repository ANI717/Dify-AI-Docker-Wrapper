# -------- builder --------
FROM golang:1.23-bookworm AS builder
ARG SANDBOX_VERSION=0.2.12
ENV CGO_ENABLED=1
WORKDIR /src

RUN apt-get update && apt-get install -y --no-install-recommends \
    git build-essential pkg-config libseccomp-dev ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# fetch source (tag with/without leading v)
RUN set -eux; ver="${SANDBOX_VERSION}"; \
    for tag in "$ver" "v$ver"; do \
      if git ls-remote --tags https://github.com/langgenius/dify-sandbox.git | grep -q "refs/tags/$tag$"; then \
        git clone --depth 1 --branch "$tag" https://github.com/langgenius/dify-sandbox.git .; \
        break; \
      fi; \
    done; \
    test -f go.mod || { echo "Tag $SANDBOX_VERSION not found"; exit 1; }

# no sudo inside containers
RUN set -eux; \
    sed -i 's/\bsudo \+//g' install.sh || true; \
    sed -i 's/\bsudo \+//g' build/build_amd64.sh || true; \
    chmod +x install.sh build/build_amd64.sh; \
    ./install.sh; \
    ./build/build_amd64.sh   # produces ./main

# -------- runtime --------
FROM debian:bookworm-slim
WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates libseccomp2 bash sed && \
    rm -rf /var/lib/apt/lists/*

# copy binary + default configs
COPY --from=builder /src/main /app/main
COPY --from=builder /src/conf /app/conf

# allow overriding at runtime
ARG SANDBOX_PORT=8194
ENV SANDBOX_PORT=${SANDBOX_PORT}
# Do NOT bake secrets; pass via --env-file at run:
#   CODE_EXECUTION_API_KEY=your-key
# If unset, the config’s default remains.

EXPOSE 8194

# entrypoint: patch config.yaml with env overrides if provided
RUN printf '%s\n' '#!/usr/bin/env bash' \
  'set -euo pipefail' \
  'cd /app' \
  'if [[ -n "${CODE_EXECUTION_API_KEY:-}" ]]; then' \
  '  sed -i -E "s|^( *apikey:).*|\\1 ${CODE_EXECUTION_API_KEY}|" conf/config.yaml || true' \
  'fi' \
  'if [[ -n "${SANDBOX_PORT:-}" ]]; then' \
  '  sed -i -E "s|^( *port:).*|\\1 ${SANDBOX_PORT}|" conf/config.yaml || true' \
  'fi' \
  'exec /app/main' > /app/entrypoint.sh \
  && chmod +x /app/entrypoint.sh

CMD ["/app/entrypoint.sh"]

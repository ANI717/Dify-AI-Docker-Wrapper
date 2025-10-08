# syntax=docker/dockerfile:1
FROM langgenius/dify-sandbox:0.2.12

# curl for healthcheck
RUN apt-get update && apt-get install -y --no-install-recommends curl \
 && rm -rf /var/lib/apt/lists/*

# writeable temp only; keep deps under /temp and symlink /dependencies
RUN mkdir -p /temp /temp/dependencies /opt/sandbox \
 && chmod -R 777 /temp \
 && ln -s /temp/dependencies /dependencies || true

# optional wrapper (keeps entrypoint tiny)
COPY start-sandbox.sh /opt/sandbox/start-sandbox.sh
RUN chmod +x /opt/sandbox/start-sandbox.sh

# sane defaults; override via --env-file
ENV TMPDIR=/temp \
    SANDBOX_PORT=8194 \
    API_KEY=dify-sandbox \
    GIN_MODE=release \
    WORKER_TIMEOUT=15 \
    ENABLE_NETWORK=true

EXPOSE 8194

ENTRYPOINT ["/opt/sandbox/start-sandbox.sh"]

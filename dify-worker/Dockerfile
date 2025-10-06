# syntax=docker/dockerfile:1
FROM langgenius/dify-api:1.9.1

# For HEALTHCHECK
RUN apt-get update && apt-get install -y --no-install-recommends curl \
  && rm -rf /var/lib/apt/lists/*

# Writable temp + app helpers
RUN mkdir -p /opt/health /opt/worker /temp && chmod 777 /temp

# Copy your helper files (keep paths as-is)
COPY health_server.py /opt/health/health_server.py
COPY start-worker.sh  /opt/worker/start-worker.sh

# Normalize CRLF -> LF and ensure exec bit (fixes '/usr/bin/env: bash\r')
RUN sed -i 's/\r$//' /opt/worker/start-worker.sh /opt/health/health_server.py \
  && chmod +x /opt/worker/start-worker.sh

# Sensible defaults; override via --env-file
ENV TMPDIR=/temp \
    HEALTH_PORT=8080

# Dify app lives here
WORKDIR /app/api

# Health endpoint port
EXPOSE 8080

# Start health server + Celery worker (your script should do both)
ENTRYPOINT ["/opt/worker/start-worker.sh"]

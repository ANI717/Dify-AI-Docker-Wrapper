# syntax=docker/dockerfile:1
ARG DIFY_TAG=1.9.1
FROM langgenius/dify-api:${DIFY_TAG}

# curl for HEALTHCHECK (tiny, reliable)
RUN apt-get update && apt-get install -y --no-install-recommends curl \
  && rm -rf /var/lib/apt/lists/*

# Put health server + launcher in the image
RUN mkdir -p /opt/health /opt/worker /temp && chmod 777 /temp
COPY health_server.py /opt/health/health_server.py
COPY start-worker.sh  /opt/worker/start-worker.sh
RUN chmod +x /opt/worker/start-worker.sh

# Defaults (you can override via .env / docker run)
ENV TMPDIR=/temp \
    HEALTH_PORT=5002

# Dify code lives here; your script runs "celery -A app.celery ..."
WORKDIR /app/api

# Health HTTP endpoint (mapped in README as host:5002 -> container:5002)
EXPOSE 5002

# Start the health server + Celery worker
ENTRYPOINT ["/opt/worker/start-worker.sh"]

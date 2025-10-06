# syntax=docker/dockerfile:1
ARG DIFY_TAG=1.9.1
FROM langgenius/dify-api:${DIFY_TAG}

# curl for HEALTHCHECK + writable /temp
RUN apt-get update && apt-get install -y --no-install-recommends curl \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p /opt/health /opt/scheduler /temp \
  && chmod 777 /temp

# Health server + start script
COPY health_server.py /opt/health/health_server.py
COPY start-scheduler.sh /opt/scheduler/start-scheduler.sh
RUN chmod +x /opt/scheduler/start-scheduler.sh

# Defaults (override via .env)
ENV TMPDIR=/temp \
    HEALTH_PORT=5003

WORKDIR /app/api
EXPOSE 5003

# Launch health server + celery beat
ENTRYPOINT ["/opt/scheduler/start-scheduler.sh"]

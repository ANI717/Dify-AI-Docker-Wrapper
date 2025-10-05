# syntax=docker/dockerfile:1
FROM langgenius/dify-api:1.9.1

# Writable temp dir
RUN mkdir -p /temp && chmod 777 /temp
ENV TMPDIR=/temp DIFY_BIND_ADDRESS=0.0.0.0 DIFY_PORT=5001

# Install supervisor
RUN apt-get update && apt-get install -y --no-install-recommends supervisor && \
    rm -rf /var/lib/apt/lists/*

# Supervisor config
COPY supervisord.conf /etc/supervisor/supervisord.conf

WORKDIR /app/api

# Replace upstream entrypoint with supervisor (so we can run 3 processes)
ENTRYPOINT ["supervisord","-n","-c","/etc/supervisor/supervisord.conf"]

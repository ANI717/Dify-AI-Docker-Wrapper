# syntax=docker/dockerfile:1
FROM langgenius/dify-api:1.9.1

# Ensure a writable temp dir exists and is used by Python/libs
RUN mkdir -p /temp && chmod 777 /temp
ENV TMPDIR=/temp \
    DIFY_BIND_ADDRESS=0.0.0.0 \
    DIFY_PORT=8080

WORKDIR /app/api
# Keep upstream ENTRYPOINT/CMD; ROLE is chosen by MODE (api|worker|beat).

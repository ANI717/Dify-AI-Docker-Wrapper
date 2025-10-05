# Use the official backend image
FROM langgenius/dify-api:latest

# Create a dedicated non-root user (numeric UID/GID works across hosts)
ARG APP_UID=65532
ARG APP_GID=65532

# Prep the only writable tree
USER root
RUN mkdir -p /temp/{storage,logs,cache,uploads,home,hf,pip-cache} \
 && chown -R ${APP_UID}:${APP_GID} /temp

# Make anything that expects /app/api/storage transparently write into /temp
# (Dify defaults to /app/api/storage when STORAGE_TYPE=local; symlink keeps that happy)
RUN rm -rf /app/api/storage && ln -s /temp/storage /app/api/storage

# Keep all temp/cache/uploads/logs under /temp
ENV TMPDIR=/temp \
    HOME=/temp/home \
    PIP_CACHE_DIR=/temp/pip-cache \
    HF_HOME=/temp/hf \
    TRANSFORMERS_CACHE=/temp/hf \
    # Dify storage config (local) -> send everything to /temp/storage
    STORAGE_TYPE=local \
    STORAGE_LOCAL_PATH=/temp/storage \
    VECTOR_STORE=qdrant \
    # Network bind/port (Dify uses these at container start)
    DIFY_BIND_ADDRESS=0.0.0.0 \
    DIFY_PORT=8080 \
    # Sensible defaults; .env can override all of these at runtime
    REDIS_URL=redis://host.docker.internal:6379/0 \
    DATABASE_URL=postgresql://dify:dify@localhost:5432/dify \
    QDRANT_URL=http://host.docker.internal:6334 \
    PORT=8080

# Run as non-root
USER ${APP_UID}:${APP_GID}

# Document the in-container port (host mapping set at `docker run`)
EXPOSE 8080

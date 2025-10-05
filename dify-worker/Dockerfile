# Single-container Dify Worker based on the official image
FROM langgenius/dify-api:latest

ARG APP_UID=10001
ARG APP_USER=appuser
RUN useradd -m -u ${APP_UID} -s /bin/bash ${APP_USER} \
 && mkdir -p /temp/storage /temp/logs /temp/uploads /temp/cache \
 && chown -R ${APP_USER}:${APP_USER} /temp

COPY health_server.py /opt/health/health_server.py
COPY start-worker.sh /usr/local/bin/start-worker.sh
RUN chmod +x /usr/local/bin/start-worker.sh

# All temps/caches/logs under /temp; set locale to avoid warnings
ENV TMPDIR=/temp \
    HOME=/temp \
    STORAGE_LOCAL_PATH=/temp/storage \
    LOG_DIR=/temp/logs \
    DATASETS_UPLOAD_TEMP_DIR=/temp/uploads \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PYTHONUNBUFFERED=1 \
    HEALTH_PORT=8080

# ----- Choose ONE storage mode -----
# (A) OpenDAL local FS (recommended on new versions)
ENV OPENDAL_SCHEME=fs \
    OPENDAL_FS_ROOT=/temp/storage
# (B) Or legacy local storage:
# ENV STORAGE_TYPE=local
# ENV STORAGE_LOCAL_PATH=/temp/storage
# -----------------------------------

WORKDIR /app/api
USER ${APP_USER}
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/start-worker.sh"]

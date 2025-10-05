FROM langgenius/dify-web:latest

# Become root just to prepare /temp, then drop back to the image's non-root user.
USER root

# Create /temp and make it safe for any non-root user (sticky bit like /tmp)
RUN mkdir -p /temp && chmod 1777 /temp

# Ensure the app writes caches/logs/tmp ONLY under /temp
ENV TMPDIR=/temp \
    XDG_CACHE_HOME=/temp/xdg-cache \
    NPM_CONFIG_CACHE=/temp/npm-cache \
    YARN_CACHE_FOLDER=/temp/yarn-cache \
    LOG_DIR=/temp/logs \
    DATA_DIR=/temp/data \
    CACHE_DIR=/temp/cache \
    PORT=8080

# Drop privileges to the base image's default user (commonly "node")
# If the image defines a different default user, this line restores it.
USER 1000

EXPOSE 8080

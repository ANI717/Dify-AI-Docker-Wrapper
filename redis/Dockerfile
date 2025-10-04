# Minimal Redis image without docker-compose
FROM alpine:3.20

# Install redis
RUN apk add --no-cache redis

# Small entrypoint to wire env vars into a config file
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Default Redis port
EXPOSE 6379

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

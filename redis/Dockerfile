# Use the official lightweight Redis image
FROM redis:7-alpine

# Expose port 6379 for external access
EXPOSE 6379

# Optional: Copy a custom redis.conf if you want to configure Redis
# COPY redis.conf /usr/local/etc/redis/redis.conf

# Run Redis server (default conf works if you don't need custom config)
CMD ["redis-server", "--bind", "0.0.0.0", "--port", "6379"]

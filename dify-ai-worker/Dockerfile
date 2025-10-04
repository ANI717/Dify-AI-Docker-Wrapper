# Minimal worker image for Dify
FROM langgenius/dify-api:latest

# Tell the upstream entrypoint to start Celery instead of the API server
ENV MODE=worker

# No EXPOSE here: worker is not an HTTP service
# Upstream entrypoint handles launching Celery based on MODE

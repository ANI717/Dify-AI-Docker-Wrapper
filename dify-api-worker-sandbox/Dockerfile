FROM langgenius/dify-api:latest

USER root
RUN apt-get update && apt-get install -y supervisor && rm -rf /var/lib/apt/lists/*

# Supervisor config
COPY supervisord.conf /etc/supervisor/conf.d/dify.conf

# API default port is 5001; sandbox default is 8194 (both internal)
EXPOSE 5001 8194

# Keep original envs overridable by .env file at runtime
ENV DIFY_PORT=5001 \
    SANDBOX_PORT=8194

# NOTE:
# - API and worker come from this image (MODE=api / MODE=worker).
# - Sandbox runs as a sidecar process inside the same container by calling
#   the sandbox server shipped in the image family (if upstream changes paths,
#   update the command in supervisord.conf).

CMD ["/usr/bin/supervisord","-n","-c","/etc/supervisor/conf.d/dify.conf"]

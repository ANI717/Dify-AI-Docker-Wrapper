# syntax=docker/dockerfile:1
FROM langgenius/dify-api:1.9.1

# Ensure a writable temp dir exists and is used by Python/libs
RUN mkdir -p /temp && chmod 777 /temp
ENV TMPDIR=/temp \
    DIFY_BIND_ADDRESS=0.0.0.0 \
    DIFY_PORT=8080

WORKDIR /app/api
# Keep upstream ENTRYPOINT/CMD; ROLE is chosen by MODE (api|worker|beat).


# --- AKV bootstrap (optional) ---
# Installs lightweight Azure SDKs and adds a small entrypoint wrapper that
# can pull secrets from Azure Key Vault into environment variables at container start.
# Enable by setting VAULT_URL (or AZURE_KEY_VAULT_URL) and SECRET_NAMES at runtime.
#
# Examples:
#   -e VAULT_URL=https://myvault.vault.azure.net/ \
#   -e SECRET_NAMES="DB_PASSWORD:prod-db-password,REDIS_URL,OPENAI_API_KEY"
#
# By default, we DO NOT override the upstream ENTRYPOINT/CMD. If you want the
# container to auto-load AKV secrets before starting, uncomment the ENTRYPOINT
# line below.

USER root
RUN pip install --no-cache-dir azure-identity azure-keyvault-secrets
COPY akv_bootstrap.py /akv_bootstrap.py
COPY akv-entrypoint.sh /akv-entrypoint.sh
RUN chmod +x /akv-entrypoint.sh /akv_bootstrap.py

# Uncomment to enable AKV-based env injection automatically:
# ENTRYPOINT ["/akv-entrypoint.sh"]
# When enabled, the wrapper will exec the base image CMD after exporting secrets.

# Runtime envs you will typically set (example values):
# ENV VAULT_URL="https://myvault.vault.azure.net/" \
#     SECRET_NAMES="DB_PASSWORD:prod-db-password,OPENAI_API_KEY"
USER 1000

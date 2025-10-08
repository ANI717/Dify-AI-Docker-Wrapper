#!/usr/bin/env python3
"""
Fetch selected secrets from Azure Key Vault and emit shell export lines.

Requires:
  - VAULT_URL: e.g., "https://myvault.vault.azure.net/"
  - SECRET_NAMES: comma-separated list. Each entry is either:
        "ENV_NAME:akv-secret-name" (explicit mapping) or
        "NAME" (use same name for env and AKV secret)

Auth:
  Uses DefaultAzureCredential. In Azure (AKS/ACI/ACA/VM) prefer Managed Identity
  or Workload Identity. Locally, az login / environment vars also work.

Output:
  Writes an export file at /tmp/akv.env with lines like:
      export FOO=bar
  Intended to be sourced by a shell before launching the app.
"""
import os
import sys
from pathlib import Path

OUT = Path(os.environ.get("AKV_ENV_FILE", "/tmp/akv.env"))
VAULT_URL = os.environ.get("VAULT_URL") or os.environ.get("AZURE_KEY_VAULT_URL")
SECRET_NAMES = os.environ.get("SECRET_NAMES", "").strip()

if not VAULT_URL:
    print("akv_bootstrap: VAULT_URL (or AZURE_KEY_VAULT_URL) is required", file=sys.stderr)
    sys.exit(1)

if not SECRET_NAMES:
    print("akv_bootstrap: SECRET_NAMES is empty; nothing to fetch", file=sys.stderr)
    sys.exit(0)

try:
    from azure.identity import DefaultAzureCredential
    from azure.keyvault.secrets import SecretClient
except Exception as e:
    print(f"akv_bootstrap: Missing dependencies: {e}", file=sys.stderr)
    sys.exit(2)

pairs = []
for raw in SECRET_NAMES.split(","):
    raw = raw.strip()
    if not raw:
        continue
    if ":" in raw:
        env_name, secret_name = raw.split(":", 1)
        env_name = env_name.strip()
        secret_name = secret_name.strip()
    else:
        env_name = secret_name = raw
    pairs.append((env_name, secret_name))

cred = DefaultAzureCredential(exclude_shared_token_cache_credential=True)
client = SecretClient(vault_url=VAULT_URL, credential=cred)

lines = []
for env_name, secret_name in pairs:
    try:
        secret = client.get_secret(secret_name)
        value = secret.value if secret and secret.value is not None else ""
        # Escape any embedded double-quotes and dollars for POSIX shell
        safe = value.replace("\\", "\\\\").replace('"', '\\"').replace("$", "\\$")
        lines.append(f'export {env_name}="{safe}"')
    except Exception as e:
        print(f"akv_bootstrap: WARN could not fetch '{secret_name}': {e}", file=sys.stderr)

OUT.write_text("\n".join(lines) + ("\n" if lines else ""))
print(f"akv_bootstrap: wrote {OUT} with {len(lines)} exports")

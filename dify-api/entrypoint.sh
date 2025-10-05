#!/bin/bash
set -euo pipefail

cd /app/api

# Optional: venv activation (PATH already contains it in your image, so this is not required)
# source /app/api/.venv/bin/activate

echo "[entrypoint] Waiting for DB..."
python - <<'PY'
import os, time
from sqlalchemy import create_engine
url = os.getenv('SQLALCHEMY_DATABASE_URI') or os.getenv('DATABASE_URL')
for i in range(60):
    try:
        create_engine(url).connect().close()
        print("DB ready")
        break
    except Exception as e:
        print(f"DB not ready yet: {e}")
        time.sleep(2)
else:
    raise SystemExit("DB not ready after timeout")
PY

echo "[entrypoint] Applying migrations..."
flask db upgrade   # idempotent; safe to run every start

echo "[entrypoint] Starting API..."
# replace this with however you start the server (gunicorn/uvicorn/python app.py)
exec gunicorn 'app_factory:create_app()' --bind 0.0.0.0:${PORT:-8080} --workers 2 --threads 4 --timeout 120

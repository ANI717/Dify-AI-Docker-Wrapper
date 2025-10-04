```bash
docker build -t dify-postgres-image:local .
docker run --name dify-postgres -p 5432:5432 --env-file .env dify-postgres-image:local
```

```python
import psycopg
try:
    conn = psycopg.connect("postgresql://dify:dify@localhost:5432/dify", connect_timeout=5)
    print("✅ Connected:", conn.info)
    conn.close()
except Exception as e:
    print("❌ Failed:", e)
```
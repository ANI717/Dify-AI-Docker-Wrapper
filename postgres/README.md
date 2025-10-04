```bash
docker build -t postgres-image:local .
docker run --name postgres-container -p 5432:5432 --env-file .env postgres-image:local
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
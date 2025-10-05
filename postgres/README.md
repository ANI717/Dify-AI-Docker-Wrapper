```bash
docker build -t postgres-image:local .
docker run --name postgres-container -p 5432:5432 --env-file .env postgres-image:local
```

```python
from sqlalchemy import create_engine, text

engine = create_engine("postgresql://dify:dify@localhost:5432/dify")

with engine.connect() as conn:
    result = conn.execute(text("SELECT 1;"))
    print(result.scalar())
```
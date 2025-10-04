```bash
docker build -t qdrant-image:local .
docker run --name qdrant-container -p 6333:6333 --env-file .env qdrant-image:local
```
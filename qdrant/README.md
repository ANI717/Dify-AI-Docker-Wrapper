```bash
docker build -t qdrant-image:local .
docker run --name dify-qdrant -p 6333:6333 --env-file .env qdrant-image:local
```
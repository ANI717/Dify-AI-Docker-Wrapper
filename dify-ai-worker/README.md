```bash
docker build -t dify-ai-worker-image:local .
docker run --name dify-ai-worker --env-file .env dify-ai-worker-image:local
```

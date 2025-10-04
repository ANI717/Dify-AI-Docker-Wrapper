```bash
docker build -t dify-api-worker-sandbox-image:local .
docker run --name dify-api-worker-sandbox -p 5001:5001 --env-file .env dify-api-worker-sandbox-image:local
```

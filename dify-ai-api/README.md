```bash
docker build -t dify-ai-api-image:local .
docker run --name dify-ai-api -p 5001:5001 --env-file .env dify-ai-api-image:local
```

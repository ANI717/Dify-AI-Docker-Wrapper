```bash
docker build -t dify-worker-image:local .
docker run --name dify-worker -p 5002:5002 --env-file .env dify-worker-image:local
```

```bash
curl -v http://localhost:5002/health
```

```bash
docker build -t dify-api-image:local .
docker run --name dify-api -p 5001:8080 --env-file .env dify-api-image:local
```

```bash
curl -v http://localhost:5001/health
```

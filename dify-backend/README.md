```bash
docker build -t dify-backend-image:local .
docker run --name dify-backend -p 5001:5001 --env-file .env dify-backend-image:local
```

```bash
curl -v http://localhost:5001/health
docker logs dify-api --tail=200
```

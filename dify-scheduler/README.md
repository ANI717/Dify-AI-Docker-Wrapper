```bash
docker build -t dify-scheduler-image:local .
docker run --name dify-scheduler -p 5003:5003 --env-file .env dify-scheduler-image:local
```

```bash
curl -v http://localhost:5003/health
```

```bash
docker build -t dify-ui-image:local .
docker run --name dify-ui -p 3000:8080 dify-ui-image:local
```

```bash
docker build -t dify-ui-image:git .
docker run --name dify-ui -p 8080:8080 dify-ui-image:git
```

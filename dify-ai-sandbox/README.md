```bash
docker build -t dify-ai-sandbox-image:local .
docker run --name dify-ai-sandbox -p 8194:8194 --env-file .env dify-ai-sandbox-image:local
```

```python
import requests
r = requests.post(
    "http://localhost:8194/v1/sandbox/run",
    headers={"X-API-Key": "dify-sandbox", "Content-Type": "application/json"},
    json={"language":"python3","code":"print('ok')","timeout":5},
)
print(r.status_code, r.text)
```
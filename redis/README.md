```bash
docker build -t redis-image:local .
docker run --name redis-container -p 6379:6379 --env-file .env redis-image:local
```

```python
import redis

r = redis.Redis(host='localhost', port=6379, decode_responses=True) # no password
# r = redis.Redis(host='localhost', port=6379, password='change_me', decode_responses=True) # password protected

r.set('ani', 'value is already set for ani key')
print(r.get('ani'))

```
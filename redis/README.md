```bash
docker build -t redis-image:local .
docker run --name dify-redis -p 6379:6379 --env-file .env redis-image:local
```

```python
import redis

# If no password
r = redis.Redis(host='localhost', port=6379, decode_responses=True)

# If password protected
# r = redis.Redis(host='localhost', port=6379, password='your_password', decode_responses=True)

r.set('foo', 'bar')
print(r.get('foo'))  # -> 'bar'

```
# Dify-AI-Docker-Wrapper
A Wrapper over Dify AI images to deploy them individually without using `docker-compose`

### Connections
```
UI (web) --HTTP--> API

API --HTTP--> Sandbox
API --SQL/TCP--> Postgres
API --HTTP--> Vector Store (Weaviate/Milvus/Qdrant/PGVector)
API --HTTP-->  Plugin Daemon (optional component)

Worker --HTTP--> Sandbox
Worker --SQL/TCP--> Postgres
Worker --HTTP--> Vector Store (Weaviate/Milvus/Qdrant/PGVector)

API --> Redis <-- Worker (queue/broker + some caching)
API --> Azure Blob/S3/Shared Volume <-- Worker (file/object storage)

Scheduler --> Redis (optional component)
```

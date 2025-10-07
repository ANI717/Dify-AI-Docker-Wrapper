# Dify-AI-Docker-Wrapper
A Wrapper over Dify AI images to deploy them individually without using `docker-compose`

## Components
**UI (web)** – React/Next.js front-end for users to build, configure, and run AI apps.  

**API** – Main backend: handles requests from the UI, stores data, manages apps, calls models, pushes async tasks.  
**Worker** – Background job runner (Celery) that executes long-running tasks from the API’s queue.  
**Scheduler** – Optional cron-like job pusher that enqueues scheduled/periodic tasks into Redis.  
**Sandbox** – Isolated runtime where user-supplied code or tools execute safely.  
**Plugin Daemon** – Lightweight sidecar that runs external plugin integrations for the API.  

**Redis** – In-memory broker/cache: task queue between API and Worker and short-term caching.  
**Postgres** – Primary relational database for all app/user/config data.  
**Vector Store (Weaviate/Milvus/Qdrant/PGVector)** – Stores embeddings for search/RAG features.  
**Object Storage (local volume, S3, Azure Blob, GCS)** — For file uploads and persisted assets, shared by API & Worker.

**Model provider keys (e.g., OpenAI API key)** — Required to call external LLMs.

## Connections
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

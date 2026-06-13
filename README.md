# TalaLM

A full stack LLM learning experience.

## Tech Stack

* **API Server:** FastAPI
* **Frontend:** ReactJS
* **Database:** PostgreSQL
* **Object Storage:** RustFS

## Local Stack

This repository includes separate Compose files for two local workflows:

* `docker-compose.yml`: default infrastructure-only stack
* `docker-compose.local-prod.yml`: immutable local-production style stack
* `docker-compose.dev.yml`: development stack with backend/frontend source bind
  mounts and hot reload

The default `docker-compose.yml` intentionally starts only PostgreSQL/pgvector
and RustFS, so `docker compose up` is a quick way to run the shared local
infrastructure while running the backend and frontend separately.

The local-production and development app stacks run:

* FastAPI backend on `http://localhost:3000`
* React frontend on `http://localhost:8000`
* PostgreSQL with pgvector on `localhost:5432`
* RustFS S3-compatible object storage on `http://localhost:9000`
* RustFS console on `http://localhost:9001`

In local-production mode, the backend and frontend run from built images and do
not mount their source trees as writable volumes. In development mode, source
code is bind-mounted for fast iteration. PostgreSQL and RustFS are the only
services with persistent named data volumes.

### Prerequisites

* Docker Engine 20.10 or newer
* Docker Compose v2 (`docker compose`)

### One-Time Setup

Create the root environment file:

```bash
cp .env.example .env
```

Keep local GGUF model files in the root `models/` directory. They are mounted
read-only into the backend container at `/app/models`.

### Infrastructure Only

Use the default Compose file when you only want local services for backend or
frontend development outside Docker:

```bash
docker compose up -d
```

This starts:

* PostgreSQL with pgvector on `localhost:5432`
* RustFS S3-compatible object storage on `http://localhost:9000`
* RustFS console on `http://localhost:9001`

Stop infrastructure services without removing persistent data:

```bash
docker compose down
```

Reset infrastructure PostgreSQL and RustFS volumes:

```bash
docker compose down -v
```

### Local Production

Use local production when you want to test the stack as packaged images, without
mounting backend or frontend source code into the running containers.

Start or rebuild the stack:

```bash
docker compose -f docker-compose.local-prod.yml up -d --build
```

This builds immutable backend/frontend images, starts PostgreSQL and RustFS, then
runs a one-shot backend migration service that applies database migrations,
seeds the default admin user, and creates the configured RustFS bucket.

Check status and logs:

```bash
docker compose -f docker-compose.local-prod.yml ps
docker compose -f docker-compose.local-prod.yml logs -f api
```

The default admin user is:

* Email: `admin@example.com`
* Password: `password`

Services will be available at:

* Frontend: `http://localhost:8000`
* API: `http://localhost:3000`
* PostgreSQL: `localhost:5432`
* RustFS S3 API: `http://localhost:9000`
* RustFS console: `http://localhost:9001`
* RustFS access key: `rustfsadmin`
* RustFS secret key: `rustfsadmin`

To stop containers without removing persistent data:

```bash
docker compose -f docker-compose.local-prod.yml down
```

To stop containers and remove local-production PostgreSQL and RustFS data:

```bash
docker compose -f docker-compose.local-prod.yml down -v
```

### Development

Use development mode when changing backend or frontend code. It bind-mounts the
application source into the app containers and runs the development servers.

```bash
docker compose -f docker-compose.dev.yml up --build
```

Development mode runs:

* FastAPI with Uvicorn reload
* React/esbuild with the frontend dev server
* PostgreSQL with a persistent named volume
* RustFS with persistent named volumes

Backend source is mounted at `/app`, so Python code changes reload
automatically. Frontend `src/`, `public/`, and `build.js` are mounted into the
Node container, so React and Sass changes rebuild through `npm run start`.

For normal Python, React, Sass, or frontend asset changes, leave the stack
running. Rebuild only when dependencies or Docker packaging change:

```bash
docker compose -f docker-compose.dev.yml build api
docker compose -f docker-compose.dev.yml build web
```

Run backend CLI commands inside the development API container:

```bash
docker compose -f docker-compose.dev.yml exec api python -m app.cli system:doctor
docker compose -f docker-compose.dev.yml exec api python -m app.cli system:restore_factory_settings
```

Stop development containers without removing data:

```bash
docker compose -f docker-compose.dev.yml down
```

Reset development PostgreSQL and RustFS volumes:

```bash
docker compose -f docker-compose.dev.yml down -v
```

The development and local-production Compose files use separate project names,
so their containers and named volumes are isolated from each other.

### Local Models

Local GGUF models are kept in the root `models/` directory and mounted into the
backend container read-only at `/app/models`. The backend image remains
immutable; only model files are exposed as read-only runtime inputs.

The backend reads `talalmapi/manifest-local-models.yml` from the image. Manifest
paths should stay relative to the backend app directory:

```yaml
-
  name: "Qwen3.5-0.8B-UD-Q6_K_XL"
  type: "inference"
  path: "models/Qwen3.5-0.8B-UD-Q6_K_XL.gguf"
```

### RustFS Details

RustFS runs as user `10001`, so the compose file includes a one-shot permission
helper container that fixes ownership before RustFS starts.

For non-default credentials, set environment variables before starting:

```bash
RUSTFS_ACCESS_KEY=localadmin RUSTFS_SECRET_KEY=localadmin123 docker compose -f docker-compose.local-prod.yml up -d
```

The Compose stacks create the configured development bucket through the
`api-migrate` service. To create it manually outside Compose, run:

```bash
bin/create_dev_bucket.sh
```

### Upload a File with boto3

Install boto3 if needed:

```bash
python -m pip install boto3
```

Create a local file and upload it to RustFS:

```python
from pathlib import Path

import boto3
from botocore.client import Config

endpoint_url = "http://localhost:9000"
access_key = "rustfsadmin"
secret_key = "rustfsadmin"
bucket_name = "talalm-local"
object_key = "examples/hello.txt"
file_path = Path("hello.txt")

file_path.write_text("Hello from TalaLM and RustFS\n", encoding="utf-8")

s3 = boto3.client(
    "s3",
    endpoint_url=endpoint_url,
    aws_access_key_id=access_key,
    aws_secret_access_key=secret_key,
    region_name="us-east-1",
    config=Config(signature_version="s3v4"),
)

try:
    s3.create_bucket(Bucket=bucket_name)
except s3.exceptions.BucketAlreadyOwnedByYou:
    pass
except s3.exceptions.BucketAlreadyExists:
    pass

s3.upload_file(str(file_path), bucket_name, object_key)

print(f"Uploaded {file_path} to s3://{bucket_name}/{object_key}")
```

You can verify the upload in the RustFS console at `http://localhost:9001`.

## Notebook Worker

Uploaded notebook files are stored in RustFS first, then embedded by a backend
worker. The worker polls `notebook_files` for `pending` records, downloads each
file from RustFS, generates embeddings, writes rows to `notebook_vectors`, and
marks the file `active` when processing succeeds.

From the API directory:

```bash
cd talalmapi
python -m app.cli system:start_notebook_worker
```

The worker runs as a foreground process and logs what it is doing every polling
cycle. It checks for one pending file every 5 seconds. Keep it running while
testing notebook uploads.

To run it in the background during local development:

```bash
cd talalmapi
nohup python -m app.cli system:start_notebook_worker > ../notebook_worker.log 2>&1 &
```

Follow the logs:

```bash
tail -f notebook_worker.log
```

Stop the background worker:

```bash
pkill -f "system:start_notebook_worker"
```

In production, run the same command under a process manager such as systemd,
supervisord, Docker Compose, or your deployment platform's worker process
facility so it restarts on failure.

# TalaLM

A full stack LLM learning experience.

## Tech Stack

* **API Server:** FastAPI
* **Frontend:** ReactJS
* **Database:** PostgreSQL
* **Object Storage:** RustFS

## Local Services

This repository includes a root `docker-compose.yml` for local development
services. For now it starts only RustFS, an S3-compatible object storage server.

### Prerequisites

* Docker Engine 20.10 or newer
* Docker Compose v2 (`docker compose`)

### Start RustFS

Create the root environment file:

```bash
cp .env.example .env
```

From the repository root:

```bash
docker compose up -d
```

Check the service status:

```bash
docker compose ps
docker compose logs -f rustfs
```

RustFS will be available at:

* S3 API: `http://localhost:9000`
* Console: `http://localhost:9001`
* Access key: `rustfsadmin`
* Secret key: `rustfsadmin`

To stop the service:

```bash
docker compose down
```

To stop the service and remove the local RustFS data volume:

```bash
docker compose down -v
```

The compose file uses Docker named volumes for RustFS data and logs. RustFS runs
as user `10001`, so the compose file also includes a one-shot permission helper
container that fixes ownership before RustFS starts.

For non-default credentials, set environment variables before starting:

```bash
RUSTFS_ACCESS_KEY=localadmin RUSTFS_SECRET_KEY=localadmin123 docker compose up -d
```

### Create the Development Bucket

Create the bucket configured in the root `.env`:

```bash
bin/create_dev_bucket.sh
```

The script reads `.env` from the repository root and uses:

* `RUSTFS_ENDPOINT`
* `RUSTFS_ACCESS_KEY`
* `RUSTFS_SECRET_KEY`
* `RUSTFS_BUCKET`
* `RUSTFS_REGION`

It also accepts the equivalent API storage variables, such as
`STORAGE_S3_BUCKET`, when `RUSTFS_*` values are not set.

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

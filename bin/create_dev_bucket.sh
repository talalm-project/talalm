#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${ROOT_DIR}/.env"

if [[ -f "${ENV_FILE}" ]]; then
  set -a
  # shellcheck disable=SC1090
  source "${ENV_FILE}"
  set +a
fi

RUSTFS_BUCKET="${RUSTFS_BUCKET:-${STORAGE_S3_BUCKET:-talalm-local}}"
RUSTFS_REGION="${RUSTFS_REGION:-${STORAGE_S3_REGION:-us-east-1}}"
RUSTFS_ENDPOINT="${RUSTFS_ENDPOINT:-${STORAGE_S3_ENDPOINT:-http://localhost:9000}}"
RUSTFS_ACCESS_KEY="${RUSTFS_ACCESS_KEY:-${STORAGE_S3_ACCESS_KEY_ID:-rustfsadmin}}"
RUSTFS_SECRET_KEY="${RUSTFS_SECRET_KEY:-${STORAGE_S3_SECRET_ACCESS_KEY:-rustfsadmin}}"

if [[ -z "${RUSTFS_BUCKET}" ]]; then
  echo "RUSTFS_BUCKET or STORAGE_S3_BUCKET must be set." >&2
  exit 1
fi

PYTHON_BIN="${PYTHON_BIN:-}"
if [[ -z "${PYTHON_BIN}" ]]; then
  if [[ -x "${ROOT_DIR}/env/bin/python" ]]; then
    PYTHON_BIN="${ROOT_DIR}/env/bin/python"
  elif command -v python3 >/dev/null 2>&1; then
    PYTHON_BIN="python3"
  else
    PYTHON_BIN="python"
  fi
fi

export RUSTFS_BUCKET
export RUSTFS_REGION
export RUSTFS_ENDPOINT
export RUSTFS_ACCESS_KEY
export RUSTFS_SECRET_KEY

"${PYTHON_BIN}" <<'PY'
import os
import sys

try:
    import boto3
    from botocore.client import Config
    from botocore.exceptions import ClientError, EndpointConnectionError
except ImportError as error:
    print(
        "boto3 is required. Install talalmapi requirements or set PYTHON_BIN to a Python with boto3.",
        file=sys.stderr,
    )
    raise SystemExit(1) from error

bucket = os.environ["RUSTFS_BUCKET"]
region = os.environ["RUSTFS_REGION"]
endpoint = os.environ["RUSTFS_ENDPOINT"]
access_key = os.environ["RUSTFS_ACCESS_KEY"]
secret_key = os.environ["RUSTFS_SECRET_KEY"]

client = boto3.client(
    "s3",
    endpoint_url=endpoint,
    aws_access_key_id=access_key,
    aws_secret_access_key=secret_key,
    region_name=region,
    config=Config(signature_version="s3v4", s3={"addressing_style": "path"}),
)

try:
    client.head_bucket(Bucket=bucket)
except EndpointConnectionError as error:
    print(f"Could not connect to RustFS at {endpoint}. Start it with: docker compose up -d", file=sys.stderr)
    raise SystemExit(1) from error
except ClientError as error:
    status_code = error.response.get("ResponseMetadata", {}).get("HTTPStatusCode")
    error_code = error.response.get("Error", {}).get("Code")
    if status_code == 404 or error_code in {"404", "NoSuchBucket", "NotFound"}:
        create_args = {"Bucket": bucket}
        if region and region != "us-east-1":
            create_args["CreateBucketConfiguration"] = {"LocationConstraint": region}
        client.create_bucket(**create_args)
        print(f"Created RustFS bucket: {bucket}")
    else:
        raise
else:
    print(f"RustFS bucket already exists: {bucket}")
PY

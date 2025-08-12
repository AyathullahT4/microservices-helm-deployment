#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "[build] api-node:v0.1.0"
docker build -t api-node:v0.1.0   "$ROOT/services/api-node"

echo "[build] api-python:v0.1.0"
docker build -t api-python:v0.1.0 "$ROOT/services/api-python"

# choose cluster: env CLUSTER overrides, else first from 'kind get clusters', else 'kdev'
CLUSTER="${CLUSTER:-$(kind get clusters 2>/dev/null | head -n1 || echo kdev)}"

if command -v kind >/dev/null 2>&1; then
  echo "[kind] loading images into kind cluster: ${CLUSTER}"
  kind load docker-image api-node:v0.1.0   --name "${CLUSTER}" || true
  kind load docker-image api-python:v0.1.0 --name "${CLUSTER}" || true
fi

echo "[done] local images ready:"
docker images | awk 'NR==1 || /api-(node|python)/'

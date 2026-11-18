#!/usr/bin/env bash
# Deploy one exact image that passed CI.
# Usage: ./scripts/deploy.sh <version-or-sha-tag>      e.g. ./scripts/deploy.sh 1.1.0
# The image must already exist locally (docker load) or in GHCR.
set -euo pipefail

TAG="${1:?Give the image tag to deploy, e.g. 1.1.0}"
REGISTRY_IMAGE="${REGISTRY_IMAGE:-ghcr.io/xoex7/service-info-page}"
CONTAINER="service-info"
BIND_ADDR="${BIND_ADDR:-192.168.56.10}"   # only listen where the lab needs it
                                      # lab VM: BIND_ADDR=192.168.56.10 (host-only network)
PORT="${PORT:-8080}"
STATE_DIR="${STATE_DIR:-$HOME/.service-info}"
mkdir -p "$STATE_DIR"

IMAGE="$REGISTRY_IMAGE:$TAG"
if ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
  echo "Pulling $IMAGE ..."
  docker pull "$IMAGE"
fi

# Remember what is running now, so rollback knows where to go back to.
if [ -f "$STATE_DIR/current" ]; then
  cp "$STATE_DIR/current" "$STATE_DIR/previous"
fi

echo "$(date -Is) Deploying $IMAGE"
docker rm -f "$CONTAINER" >/dev/null 2>&1 || true
docker run -d --name "$CONTAINER" \
  --restart unless-stopped \
  -p "$BIND_ADDR:$PORT:5000" \
  "$IMAGE"

# Check health on the same address the port is published on.
# (Before this fix it always checked 127.0.0.1, so BIND_ADDR=<host-only IP>
#  reported a false "FAILED health check" even though the service was up.)
if bash "$(dirname "$0")/healthcheck.sh" "http://$BIND_ADDR:$PORT/health"; then
  echo "$TAG" > "$STATE_DIR/current"
  echo "$(date -Is) deploy $TAG OK" >> "$STATE_DIR/history.log"
  docker image inspect --format 'Deployed image ID: {{.Id}}' "$IMAGE"
else
  echo "$(date -Is) deploy $TAG FAILED health check" | tee -a "$STATE_DIR/history.log"
  echo "Run ./scripts/rollback.sh to restore the previous version."
  exit 1
fi

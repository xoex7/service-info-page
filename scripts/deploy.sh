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
# Never publish on all interfaces: Docker-published ports bypass ufw (risk R8).
if [ "$BIND_ADDR" = "0.0.0.0" ]; then
  echo "Refusing BIND_ADDR=0.0.0.0: use 192.168.56.10 (lab) or 127.0.0.1" >&2
  exit 1
fi
# Deployment history is shared by the whole team (group devops), so any member
# can roll back after someone else deployed. Before this change it was kept in
# each user's $HOME, and rollback.sh failed for everyone except the last
# deployer (RB-001, Part G improvement).
STATE_DIR="${STATE_DIR:-/opt/service-info/state}"
umask 0002                       # new history files stay writable for the group
if ! mkdir -p "$STATE_DIR" 2>/dev/null || [ ! -w "$STATE_DIR" ]; then
  echo "Cannot write deployment history to $STATE_DIR." >&2
  echo "Are you in the devops group? (check with: id)" >&2
  exit 1
fi
WHO="$(id -un)"

IMAGE="$REGISTRY_IMAGE:$TAG"
if ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
  echo "Pulling $IMAGE ..."
  docker pull "$IMAGE"
fi

# Remember what is running now, so rollback knows where to go back to.
# (Skip when re-deploying the same version, or "previous" would point to itself.)
if [ -f "$STATE_DIR/current" ] && [ "$(cat "$STATE_DIR/current")" != "$TAG" ]; then
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
  echo "$(date -Is) $WHO deploy $TAG OK" >> "$STATE_DIR/history.log"
  docker image inspect --format 'Deployed image ID: {{.Id}}' "$IMAGE"
else
  echo "$(date -Is) $WHO deploy $TAG FAILED health check" | tee -a "$STATE_DIR/history.log"
  echo "Run ./scripts/rollback.sh to restore the previous version."
  exit 1
fi

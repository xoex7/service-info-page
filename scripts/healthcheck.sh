#!/usr/bin/env bash
# Check that the service answers on /health. Exit 0 = healthy, 1 = not healthy.
# Usage: ./scripts/healthcheck.sh [url]
URL="${1:-http://127.0.0.1:${PORT:-8080}/health}"

for i in $(seq 1 15); do
  if BODY=$(curl -fs --max-time 2 "$URL"); then
    echo "$(date -Is) HEALTHY $URL -> $BODY"
    exit 0
  fi
  sleep 1
done
echo "$(date -Is) UNHEALTHY: no good answer from $URL after 15 tries"
exit 1

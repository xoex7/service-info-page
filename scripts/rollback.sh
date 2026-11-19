#!/usr/bin/env bash
# Go back to the previous known working release and time how long it takes.
# Usage: ./scripts/rollback.sh            (uses the saved previous version)
#        ./scripts/rollback.sh 1.0.0      (or name the version)
set -euo pipefail

# Shared team history, written by deploy.sh (see the comment there).
STATE_DIR="${STATE_DIR:-/opt/service-info/state}"
umask 0002
TARGET="${1:-$(cat "$STATE_DIR/previous" 2>/dev/null || true)}"
if [ -z "$TARGET" ]; then
  echo "No previous version known in $STATE_DIR. Give one: ./scripts/rollback.sh 1.0.0"
  exit 1
fi

START=$(date +%s)
echo "$(date -Is) Rolling back to $TARGET"
bash "$(dirname "$0")/deploy.sh" "$TARGET"
END=$(date +%s)
echo "$(date -Is) $(id -un) rollback to $TARGET done in $((END - START)) seconds" \
  | tee -a "$STATE_DIR/history.log"

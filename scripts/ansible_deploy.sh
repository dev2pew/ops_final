#!/usr/bin/env bash

set -euo pipefail
cd "$(dirname "$0")/.."

COMPOSE_FILE="docker/compose.ansible.yml"
LEGACY_CONTAINER="devops-target"
SSH_PORT=2222

echo "deploying ansible target"
if docker ps -a --format '{{.Names}}' | grep -q "^${LEGACY_CONTAINER}$"; then
    echo "removing legacy container... '${LEGACY_CONTAINER}'"
    docker rm -f "${LEGACY_CONTAINER}"
fi

docker compose -f "$COMPOSE_FILE" --project-directory docker down --remove-orphans
docker compose -f "$COMPOSE_FILE" --project-directory docker up -d

echo "container started. waiting for ssh..."

RETRIES=0
MAX_RETRIES=30

while ! (echo > /dev/tcp/127.0.0.1/"$SSH_PORT") >/dev/null 2>&1; do
  sleep 1
  RETRIES=$((RETRIES+1))
  if [ "$RETRIES" -ge "$MAX_RETRIES" ]; then
    echo "timeout waiting for ssh on port... $SSH_PORT"
    exit 1
  fi
done

sleep 2
echo "target ready."

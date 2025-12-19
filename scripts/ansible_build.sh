#!/usr/bin/env bash

set -euo pipefail
cd "$(dirname "$0")/.."

COMPOSE_FILE="docker/compose.ansible.yml"

echo "building ansible target image"
docker compose -f "$COMPOSE_FILE" --project-directory docker build

echo "all done."

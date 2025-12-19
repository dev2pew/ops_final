#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")/.."

COMPOSE_FILE="docker/compose.ansible.yml"

echo "--- Building Ansible Target Image ---"

# Explicitly set project directory to docker/ since context is local to that folder
docker compose -f "$COMPOSE_FILE" --project-directory docker build

echo "--- Build Complete ---"

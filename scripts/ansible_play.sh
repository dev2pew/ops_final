#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")/.."

# Ensure inventory file has correct permissions (Ansible security check)
chmod 644 ansible/inventory.ini 2>/dev/null || true

echo "--- Running Ansible Playbook ---"
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml

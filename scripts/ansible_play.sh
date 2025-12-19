#!/usr/bin/env bash

set -euo pipefail
cd "$(dirname "$0")/.."

chmod 644 ansible/inventory.ini 2>/dev/null || true

echo "running ansible playbook..."
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml

echo "all done."

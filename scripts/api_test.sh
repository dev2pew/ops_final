#!/usr/bin/env bash

set -euo pipefail

BASE_URL="http://localhost:8080/api/todos"
AUTH="admin:admin123"

echo "--- 1. Testing Health Check ---"
curl -s http://localhost:8080/actuator/health | grep "UP"

echo -e "\n\n--- 2. Create Todo ---"
curl -u $AUTH -X POST -H "Content-Type: application/json" \
-d '{"task":"Learn Gradle", "completed": false}' $BASE_URL

echo -e "\n\n--- 3. Test Validation (Empty Task) ---"
# Should return 400 Bad Request
curl -u $AUTH -X POST -H "Content-Type: application/json" \
-d '{"task":""}' $BASE_URL || true

echo -e "\n\n--- 4. Get All Todos ---"
curl -u $AUTH $BASE_URL
echo ""

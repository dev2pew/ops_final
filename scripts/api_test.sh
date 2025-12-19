#!/usr/bin/env bash

set -euo pipefail

BASE_URL="http://localhost:8080/api/todos"
AUTH="admin:admin123"

echo "testing health check..."
curl -s http://localhost:8080/actuator/health | grep "UP"

echo "create todo..."
curl -u $AUTH -X POST -H "Content-Type: application/json" -d '{"task":"Finish X task", "completed": false}' $BASE_URL

# EXPECTED RESULT IS 400
echo "test validation - empty task..."
curl -u $AUTH -X POST -H "Content-Type: application/json" -d '{"task":""}' $BASE_URL || true

echo "get all todos..."
curl -u $AUTH $BASE_URL

echo "all done."

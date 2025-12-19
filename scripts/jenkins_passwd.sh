#!/usr/bin/env bash

set -euo pipefail

docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword

echo "all done."

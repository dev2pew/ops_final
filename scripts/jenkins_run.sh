#!/usr/bin/env bash

set -euo pipefail

docker run -d \
  --name jenkins \
  --restart=unless-stopped \
  -p 8081:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(pwd):/opt/repo \
  --env JAVA_OPTS="-Dhudson.plugins.git.GitSCM.ALLOW_LOCAL_CHECKOUT=true" \
  --group-add $(getent group docker | cut -d: -f3) \
  my-jenkins:custom

docker exec jenkins git config --global --add safe.directory /opt/repo

echo "all done."

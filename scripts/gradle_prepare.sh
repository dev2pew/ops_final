#!/usr/bin/env bash

set -euo pipefail
cd "$(dirname "$0")/.."

APP_DIR="app"
GRADLE_IMAGE="gradle:8.5-jdk17"

echo "starting gradle preparation..."

if [ ! -f "$APP_DIR/gradlew" ]; then
    echo "gradle wrapper not found. generating using docker..."

    docker run --rm \
        --user "$(id -u):$(id -g)" \
        --volume "$(pwd)/$APP_DIR":/app \
        --workdir /app \
        "$GRADLE_IMAGE" \
        gradle wrapper

    echo "gradle wrapper generated successfully."
else
    echo "gradle wrapper already exists. Skipping generation."
fi

# PERMISSIONS
echo "ensuring executable permissions..."
chmod +x "$APP_DIR/gradlew"

# BUILD
echo "building the application... (clean build)"

cd "$APP_DIR"
./gradlew clean build -x test

echo "preparation complete. artifacts are in '$APP_DIR/build/libs/'"

echo "all done."

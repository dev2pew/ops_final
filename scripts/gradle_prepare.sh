#!/usr/bin/env bash

set -euo pipefail

# Navigate to the project root directory (one level up from scripts/)
cd "$(dirname "$0")/.."

APP_DIR="app"
GRADLE_IMAGE="gradle:8.5-jdk17"

echo "🚀 Starting Gradle Preparation..."

# --- 1. Generate Gradle Wrapper (Dockerized) ---
# We use Docker to generate the wrapper to ensure compatibility with Spring Boot 3.2.0
# and to avoid the "Gradle 4.4.1" error on your local machine.

if [ ! -f "$APP_DIR/gradlew" ]; then
    echo "⬇️  Gradle Wrapper not found. Generating using Docker..."

    docker run --rm \
        --user "$(id -u):$(id -g)" \
        --volume "$(pwd)/$APP_DIR":/app \
        --workdir /app \
        "$GRADLE_IMAGE" \
        gradle wrapper

    echo "✅ Gradle Wrapper generated successfully."
else
    echo "✅ Gradle Wrapper already exists. Skipping generation."
fi

# --- 2. Fix Permissions ---
echo "🔒 Ensuring executable permissions..."
chmod +x "$APP_DIR/gradlew"

# --- 3. Build Application ---
echo "🔨 Building the application (Clean Build)..."

cd "$APP_DIR"
./gradlew clean build -x test

echo ""
echo "🎉 Preparation Complete! Artifacts are in $APP_DIR/build/libs/"

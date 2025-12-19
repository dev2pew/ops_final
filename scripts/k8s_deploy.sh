#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

cd "$(dirname "$0")/.."

echo "🚀 Starting Deployment Script..."

# --- 1. Smart Install: Only download if not present ---
if ! command -v minikube &> /dev/null; then
    echo "⬇️  Minikube not found. Downloading..."
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
    rm minikube-linux-amd64
else
    echo "✅ Minikube is already installed."
fi

# --- 2. Smart Start: Only start if not running ---
if ! minikube status | grep -q "Running"; then
    echo "🔥 Starting Minikube..."
    minikube start
else
    echo "✅ Minikube is already running."
fi

# --- 3. Apply Manifests ---
echo "📦 Applying Kubernetes Manifests..."

# Updated paths to k8s/ folder
kubectl apply -f k8s/configmap.yml
kubectl apply -f k8s/secret.yml
kubectl apply -f k8s/postgres.yml
kubectl apply -f k8s/deployment.yml
kubectl apply -f k8s/service.yml
kubectl apply -f k8s/hpa.yml

# --- 4. Wait for Rollout ---
echo "⏳ Waiting for Database to be ready..."
kubectl wait --for=condition=ready pod -l app=postgres --timeout=90s

echo "⏳ Waiting for Notes App to be ready..."
kubectl rollout status deployment/notes-app --timeout=90s

# --- 5. Access and Test (Port Forwarding method) ---
echo "🔌 Setting up Port Forwarding for testing..."

kubectl port-forward service/notes-service 8080:8080 > /dev/null 2>&1 &

PF_PID=$!

sleep 5

echo "🧪 Running connectivity test..."

if curl -f -s -u admin:admin123 "http://localhost:8080/notes"; then
    echo ""
    echo "✅ Test Successful: Data received from API."
else
    echo ""
    echo "❌ Test Failed: Could not connect to API."
fi

# --- 6. Cleanup ---
kill $PF_PID

echo ""
echo "🎉 Deployment Complete!"

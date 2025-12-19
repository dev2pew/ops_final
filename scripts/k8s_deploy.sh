#!/usr/bin/env bash

set -e
cd "$(dirname "$0")/.."

echo "starting deployment script..."

# INSTALL
if ! command -v minikube &> /dev/null; then
    echo "minikube not found. downloading..."
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
    rm minikube-linux-amd64
else
    echo "minikube is already installed."
fi

# START
if ! minikube status | grep -q "Running"; then
    echo "starting minikube..."
    minikube start
else
    echo "minikube is already running..."
fi

# APPLY
echo "applying kubernetes manifests..."

# Updated paths to k8s/ folder
kubectl apply -f k8s/configmap.yml
kubectl apply -f k8s/secret.yml
kubectl apply -f k8s/postgres.yml
kubectl apply -f k8s/deployment.yml
kubectl apply -f k8s/service.yml
kubectl apply -f k8s/hpa.yml

# ROLLOUT WAIT
echo "waiting for database to be ready..."
kubectl wait --for=condition=ready pod -l app=postgres --timeout=90s

echo "waiting for the application to be ready..."
kubectl rollout status deployment/notes-app --timeout=90s

# PORT FORWARD - TEST
echo "setting up port forwarding for testing..."
kubectl port-forward service/notes-service 8080:8080 > /dev/null 2>&1 &

PF_PID=$!

sleep 5
echo "running connectivity test..."

if curl -f -s -u admin:admin123 "http://localhost:8080/notes"; then
    echo "success. data received from API."
else
    echo "failed... could not connect to API..."
fi

# CLEANUP
kill $PF_PID
echo "deployment complete..."

echo "all done."

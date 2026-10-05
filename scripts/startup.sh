#!/bin/bash
set -e

# Determine the directory where this script resides to resolve relative paths reliably
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
K8S_DIR="${SCRIPT_DIR}/../k8s"

echo "Applying Kubernetes manifests in dependency order..."

# 1. Foundation: Configuration & Secrets
kubectl apply -f "${K8S_DIR}/redis-configmap.yaml"
kubectl apply -f "${K8S_DIR}/redis-secret.yaml"

# 2. Storage
kubectl apply -f "${K8S_DIR}/redis-pvc.yaml"

# 3. Services (Internal DNS routing)
kubectl apply -f "${K8S_DIR}/redis-service.yaml"
kubectl apply -f "${K8S_DIR}/service.yaml"

# 4. Workloads (Deployments)
kubectl apply -f "${K8S_DIR}/redis-deployments.yaml"
kubectl apply -f "${K8S_DIR}/deployment.yaml"

echo "All manifests applied successfully."

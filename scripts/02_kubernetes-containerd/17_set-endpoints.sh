#!/bin/bash

STATIC_IP="10.10.10.10"
NAMESPACE="semafor"

echo "Setting Kubernetes endpoints for $NAMESPACE..."

# Set the Kubernetes API server endpoint
kubectl config set-cluster kubernetes --server=https://$STATIC_IP:6443

echo "Current cluster info:"
kubectl cluster-info

echo "Endpoints:"
kubectl get endpoints --all-namespaces

echo "Kubernetes endpoints configured."

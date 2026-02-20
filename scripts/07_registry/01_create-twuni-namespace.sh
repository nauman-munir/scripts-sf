#!/bin/bash

NAMESPACE="twuni"

echo "Creating $NAMESPACE namespace..."

kubectl create namespace $NAMESPACE 2>/dev/null || echo "Namespace $NAMESPACE already exists."

echo "Namespaces:"
kubectl get namespaces

echo "Namespace $NAMESPACE is ready."

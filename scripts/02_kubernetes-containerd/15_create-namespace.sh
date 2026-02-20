#!/bin/bash

NAMESPACE="semafor"

echo "Creating the $NAMESPACE namespace..."

kubectl create namespace $NAMESPACE 2>/dev/null || echo "Namespace $NAMESPACE already exists."

echo "Namespaces:"
kubectl get namespaces

echo "Namespace $NAMESPACE is ready."

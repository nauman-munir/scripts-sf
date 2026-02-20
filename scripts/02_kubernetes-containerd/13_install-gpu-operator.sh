#!/bin/bash

echo "Installing NVIDIA GPU Operator via Helm..."

# Add the NVIDIA Helm repository
helm repo add nvidia https://helm.ngc.nvidia.com/nvidia
helm repo update

# Install the GPU operator
helm install gpu-operator nvidia/gpu-operator \
    --namespace gpu-operator \
    --create-namespace \
    --set driver.enabled=false \
    --set toolkit.enabled=false

echo "Waiting for GPU Operator pods..."
kubectl -n gpu-operator get pods

echo "NVIDIA GPU Operator installation initiated."
echo "Run 'kubectl -n gpu-operator get pods' to monitor progress."

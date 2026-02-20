#!/bin/bash

echo "Testing if Kubernetes can see the NVIDIA GPU..."

# Run a test pod with nvidia-smi
kubectl run nvidia-test --rm -it --restart=Never \
    --image=nvidia/cuda:12.2.0-base-ubuntu22.04 \
    --limits=nvidia.com/gpu=1 \
    -- nvidia-smi

echo ""
echo "If you see GPU info above, Kubernetes can access the NVIDIA GPU."

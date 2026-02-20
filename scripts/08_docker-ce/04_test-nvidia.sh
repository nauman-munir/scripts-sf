#!/bin/bash

echo "Testing NVIDIA visibility in Docker..."

sudo docker run --rm --gpus all nvidia/cuda:12.2.0-base-ubuntu22.04 nvidia-smi

echo ""
echo "If you see GPU info above, Docker can access the NVIDIA GPU."

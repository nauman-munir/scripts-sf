#!/bin/bash

echo "Configuring NVIDIA Container Toolkit for containerd..."

# Configure containerd to use NVIDIA runtime
sudo nvidia-ctk runtime configure --runtime=containerd

# Restart containerd to apply changes
sudo systemctl restart containerd

echo "Containerd NVIDIA runtime configuration:"
grep -A 5 "nvidia" /etc/containerd/config.toml 2>/dev/null || echo "Check /etc/containerd/config.toml manually"

echo "NVIDIA Toolkit configured for containerd."

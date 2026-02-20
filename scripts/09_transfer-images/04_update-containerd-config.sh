#!/bin/bash

CONFIG_FILE="/etc/containerd/config.toml"
REGISTRY="semafor.local:30500"

echo "Redirecting container image URLs to local Twuni registry..."

# Backup current config
sudo cp $CONFIG_FILE ${CONFIG_FILE}.bak.$(date +%Y%m%d%H%M%S)

# Add mirror configurations to redirect common registries to local Twuni
sudo tee -a $CONFIG_FILE > /dev/null <<EOF

# Mirror configurations - redirect to local Twuni registry
[plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"]
  endpoint = ["http://$REGISTRY"]

[plugins."io.containerd.grpc.v1.cri".registry.mirrors."registry.k8s.io"]
  endpoint = ["http://$REGISTRY"]

[plugins."io.containerd.grpc.v1.cri".registry.mirrors."quay.io"]
  endpoint = ["http://$REGISTRY"]

[plugins."io.containerd.grpc.v1.cri".registry.mirrors."ghcr.io"]
  endpoint = ["http://$REGISTRY"]
EOF

# Restart containerd to apply changes
sudo systemctl restart containerd

echo "Containerd restarted with local registry mirrors."
sudo systemctl status containerd --no-pager

echo "URLs now redirect to $REGISTRY."

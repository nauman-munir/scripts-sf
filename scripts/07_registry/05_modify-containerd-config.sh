#!/bin/bash

CONFIG_FILE="/etc/containerd/config.toml"

echo "Configuring containerd for NVIDIA GPUs..."

# Backup current config
sudo cp $CONFIG_FILE ${CONFIG_FILE}.bak

# Configure NVIDIA runtime as default
sudo nvidia-ctk runtime configure --runtime=containerd --set-as-default

# Add insecure registry config for local Twuni registry
if ! grep -q "registry.mirrors" $CONFIG_FILE; then
    sudo tee -a $CONFIG_FILE > /dev/null <<EOF

[plugins."io.containerd.grpc.v1.cri".registry.mirrors."semafor.local:30500"]
  endpoint = ["http://semafor.local:30500"]

[plugins."io.containerd.grpc.v1.cri".registry.configs."semafor.local:30500".tls]
  insecure_skip_verify = true
EOF
fi

# Restart containerd
sudo systemctl restart containerd

echo "Containerd configured for NVIDIA GPUs and local registry."
sudo systemctl status containerd --no-pager

#!/bin/bash

echo "Installing containerd..."

# Install containerd
sudo apt-get update
sudo apt-get install -y containerd

# Create default config directory
sudo mkdir -p /etc/containerd

# Generate default config
containerd config default | sudo tee /etc/containerd/config.toml > /dev/null

# Enable SystemdCgroup (required for Kubernetes)
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

# Restart and enable containerd
sudo systemctl restart containerd
sudo systemctl enable containerd

echo "Containerd status:"
sudo systemctl status containerd --no-pager

echo "Containerd installation complete."

#!/bin/bash

K8S_VERSION="v1.31"

echo "Setting up keyrings for Kubernetes $K8S_VERSION..."

# Create keyrings directory
sudo mkdir -p /etc/apt/keyrings

# Download the Kubernetes signing key
curl -fsSL "https://pkgs.k8s.io/core:/stable:/$K8S_VERSION/deb/Release.key" | \
    sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Add the Kubernetes apt repository
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$K8S_VERSION/deb/ /" | \
    sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update

echo "Kubernetes keyrings and repository configured."

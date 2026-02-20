#!/bin/bash

echo "Installing Kubernetes components..."

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl

# Prevent Kubernetes packages from being updated
sudo apt-mark hold kubelet kubeadm kubectl

echo "Installed versions:"
kubeadm version
kubelet --version
kubectl version --client

echo "Held packages:"
apt-mark showhold

echo "Kubernetes installation complete."

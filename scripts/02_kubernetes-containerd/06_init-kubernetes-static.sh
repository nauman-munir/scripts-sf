#!/bin/bash

STATIC_IP="10.10.10.10"
POD_NETWORK="10.244.0.0/16"

echo "Initializing Kubernetes on $STATIC_IP..."
echo "Pod Network CIDR: $POD_NETWORK"

sudo kubeadm init \
    --apiserver-advertise-address=$STATIC_IP \
    --pod-network-cidr=$POD_NETWORK

# Setup kubectl for the current user
echo "Configuring kubectl for current user..."
mkdir -p $HOME/.kube
sudo cp -f /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "Kubernetes initialized. Verifying..."
kubectl get nodes

echo "Kubernetes initialization complete on $STATIC_IP."

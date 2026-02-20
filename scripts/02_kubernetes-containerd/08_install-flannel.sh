#!/bin/bash

echo "Installing Flannel CNI..."

kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

echo "Waiting for Flannel pods to be ready..."
kubectl wait --for=condition=ready pod -l app=flannel -n kube-flannel --timeout=120s

echo "Flannel CNI status:"
kubectl get pods -n kube-flannel

echo "Flannel CNI installation complete."

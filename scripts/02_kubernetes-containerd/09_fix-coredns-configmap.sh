#!/bin/bash

echo "Fixing CoreDNS configmap resolution..."

# Patch the CoreDNS configmap to fix DNS resolution issues
kubectl -n kube-system get configmap coredns -o yaml | \
    sed 's/forward \. \/etc\/resolv.conf/forward . 8.8.8.8 8.8.4.4/' | \
    kubectl apply -f -

# Restart CoreDNS pods to apply changes
kubectl -n kube-system rollout restart deployment coredns

echo "Waiting for CoreDNS rollout..."
kubectl -n kube-system rollout status deployment coredns --timeout=60s

echo "CoreDNS configmap fixed."
kubectl -n kube-system get pods -l k8s-app=kube-dns

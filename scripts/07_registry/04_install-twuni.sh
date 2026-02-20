#!/bin/bash

NAMESPACE="twuni"

echo "Installing Docker Registry (Twuni) in Kubernetes..."

helm install docker-registry twuni/docker-registry \
    --namespace $NAMESPACE \
    --set persistence.enabled=true \
    --set persistence.existingClaim=docker-registry-pvc \
    --set service.type=NodePort \
    --set service.nodePort=30500

echo "Waiting for registry pod..."
kubectl -n $NAMESPACE get pods

echo "Registry service:"
kubectl -n $NAMESPACE get svc

echo "Docker Registry installed in namespace $NAMESPACE."
echo "Registry accessible at: <node-ip>:30500"

#!/bin/bash

echo "Deleting completed pods across all namespaces..."

kubectl get pods --all-namespaces --field-selector=status.phase==Succeeded -o json | \
    kubectl delete -f - 2>/dev/null || echo "No completed pods found."

echo "Remaining pods:"
kubectl get pods --all-namespaces

echo "Completed pods cleanup done."

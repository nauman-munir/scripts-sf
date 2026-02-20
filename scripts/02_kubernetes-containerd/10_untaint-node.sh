#!/bin/bash

echo "Untainting master node for workload scheduling..."

NODE_NAME=$(kubectl get nodes -o jsonpath='{.items[0].metadata.name}')

kubectl taint nodes "$NODE_NAME" node-role.kubernetes.io/control-plane:NoSchedule- 2>/dev/null || true
kubectl taint nodes "$NODE_NAME" node-role.kubernetes.io/master:NoSchedule- 2>/dev/null || true

echo "Node taints after removal:"
kubectl describe node "$NODE_NAME" | grep -A 5 "Taints:"

echo "Master node $NODE_NAME untainted for scheduling."

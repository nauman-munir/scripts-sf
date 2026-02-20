#!/bin/bash

NAMESPACE="twuni"

echo "Creating persistent volume claims for Docker registry..."

kubectl apply -n $NAMESPACE -f - <<EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: docker-registry-pvc
  namespace: $NAMESPACE
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: nfs-client
  resources:
    requests:
      storage: 50Gi
EOF

echo "PVC status:"
kubectl -n $NAMESPACE get pvc

echo "Persistent volume claim created."

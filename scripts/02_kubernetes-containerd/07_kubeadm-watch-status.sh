#!/bin/bash

echo "Watching Kubernetes pod status (Run in separate terminal)..."
echo "Press Ctrl+C to stop watching."
echo ""

watch -n 2 'kubectl get pods --all-namespaces -o wide'

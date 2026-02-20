#!/bin/bash

echo "Installing Prometheus Stack CRDs..."

# Add the prometheus-community Helm repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Install kube-prometheus-stack (includes Prometheus, Grafana, Alertmanager CRDs)
helm install prometheus-stack prometheus-community/kube-prometheus-stack \
    --namespace monitoring \
    --create-namespace

echo "Waiting for CRD pods to come up..."
kubectl -n monitoring get pods

echo "Prometheus Stack CRDs installed."
echo "Run 'kubectl -n monitoring get pods' to monitor status."

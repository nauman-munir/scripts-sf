#!/bin/bash

echo "Uninstalling Prometheus Stack (Cleanup)..."

# Uninstall the Helm release
helm uninstall prometheus-stack --namespace monitoring 2>/dev/null || echo "Release not found."

# Delete the monitoring namespace
kubectl delete namespace monitoring 2>/dev/null || echo "Namespace not found."

# Clean up CRDs
kubectl delete crd alertmanagerconfigs.monitoring.coreos.com 2>/dev/null
kubectl delete crd alertmanagers.monitoring.coreos.com 2>/dev/null
kubectl delete crd podmonitors.monitoring.coreos.com 2>/dev/null
kubectl delete crd probes.monitoring.coreos.com 2>/dev/null
kubectl delete crd prometheusagents.monitoring.coreos.com 2>/dev/null
kubectl delete crd prometheuses.monitoring.coreos.com 2>/dev/null
kubectl delete crd prometheusrules.monitoring.coreos.com 2>/dev/null
kubectl delete crd scrapeconfigs.monitoring.coreos.com 2>/dev/null
kubectl delete crd servicemonitors.monitoring.coreos.com 2>/dev/null
kubectl delete crd thanosrulers.monitoring.coreos.com 2>/dev/null

echo "Prometheus Stack cleanup complete."

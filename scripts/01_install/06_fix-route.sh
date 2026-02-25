#!/bin/bash

# =============================================================================
# 06_fix-route.sh
# Verifies and fixes the Kubernetes static network route.
# Routes are managed by netplan (50-k8s-static.yaml), so this script
# only needs to check and re-apply if something went wrong.
# =============================================================================

K8S_NETWORK="10.10.10.0/21"
K8S_GATEWAY="10.10.10.1"

echo "=== Checking Kubernetes Network Route ==="

# Check if the route exists
if ip route show | grep -q "$K8S_NETWORK"; then
    echo "✅ Route to $K8S_NETWORK already exists:"
    ip route show | grep "$K8S_NETWORK"
else
    echo "⚠️  Route to $K8S_NETWORK is missing. Re-applying netplan..."
    sudo netplan apply

    # Verify after re-apply
    if ip route show | grep -q "$K8S_NETWORK"; then
        echo "✅ Route restored successfully:"
        ip route show | grep "$K8S_NETWORK"
    else
        echo "❌ Failed to restore route. Check /etc/netplan/50-k8s-static.yaml" >&2
        exit 1
    fi
fi

echo ""
echo "=== Full Routing Table ==="
ip route show

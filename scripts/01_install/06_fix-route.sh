#!/bin/bash

# =============================================================================
# 06_fix-route.sh
# Verifies the Kubernetes static network is properly configured.
# The route is auto-created by the kernel when the static IP is assigned.
# =============================================================================

STATIC_IP="10.10.10.10"
K8S_SUBNET="10.10.10.0/21"
K8S_IFACE=$(ip -o addr show | grep "$STATIC_IP" | awk '{print $2}')

echo "=== Checking Kubernetes Network ==="

if [ -z "$K8S_IFACE" ]; then
    echo "❌ Static IP $STATIC_IP is not assigned to any interface."
    echo "   Run 05_configure-static-network.sh first."
    exit 1
fi

echo "✅ Static IP $STATIC_IP is on interface: $K8S_IFACE"

# Check if the subnet route exists (kernel auto-creates this)
if ip route show | grep -q "$K8S_SUBNET"; then
    echo "✅ Route to $K8S_SUBNET exists:"
    ip route show | grep "$K8S_SUBNET"
else
    echo "⚠️  Route to $K8S_SUBNET is missing. Re-applying netplan..."
    sudo netplan apply
    sleep 3

    if ip route show | grep -q "$K8S_SUBNET"; then
        echo "✅ Route restored:"
        ip route show | grep "$K8S_SUBNET"
    else
        echo "❌ Failed to restore route. Check /etc/netplan/50-k8s-static.yaml" >&2
        exit 1
    fi
fi

echo ""
echo "=== Full Routing Table ==="
ip route show

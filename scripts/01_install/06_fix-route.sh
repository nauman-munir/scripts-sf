#!/bin/bash

# =============================================================================
# 06_fix-route.sh
# Verifies the Kubernetes static network is properly configured.
# The route is auto-created by the kernel when the static IP is assigned.
# =============================================================================

STATIC_IP="10.10.10.10"

K8S_IFACE=$(ip -o addr show | grep "$STATIC_IP" | awk '{print $2}')

echo "=== Checking Kubernetes Network ==="

if [ -z "$K8S_IFACE" ]; then
    echo "❌ Static IP $STATIC_IP is not assigned to any interface."
    echo "   Run 05_configure-static-network.sh first."
    exit 1
fi

echo "✅ Static IP $STATIC_IP is on interface: $K8S_IFACE"

# Check if any route exists for the Kubernetes interface (kernel auto-creates this)
K8S_ROUTE=$(ip route show dev "$K8S_IFACE" | head -1)

if [ -n "$K8S_ROUTE" ]; then
    echo "✅ Route exists on $K8S_IFACE:"
    ip route show dev "$K8S_IFACE"
else
    echo "⚠️  No route found on $K8S_IFACE. Re-applying netplan..."
    sudo netplan apply
    sleep 3

    K8S_ROUTE=$(ip route show dev "$K8S_IFACE" | head -1)
    if [ -n "$K8S_ROUTE" ]; then
        echo "✅ Route restored:"
        ip route show dev "$K8S_IFACE"
    else
        echo "❌ Failed to restore route. Check /etc/netplan/50-k8s-static.yaml" >&2
        exit 1
    fi
fi

echo ""
echo "=== Full Routing Table ==="
ip route show

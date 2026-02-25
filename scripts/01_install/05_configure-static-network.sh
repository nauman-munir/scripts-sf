#!/bin/bash

# =============================================================================
# 05_configure-static-network.sh
# Two-adapter setup:
#   - Adapter 1 (default route): DHCP for internet access (untouched)
#   - Adapter 2 (no default route): Static IP for Kubernetes cluster network
#
# The script auto-detects the second adapter (the one WITHOUT a default route).
# =============================================================================

STATIC_IP="10.10.10.10"
SUBNET_PREFIX="21"
K8S_GATEWAY="10.10.10.1"
K8S_NETWORK="10.10.10.0/21"

# --- Detect interfaces ---
# Internet adapter: the one with the default route
INET_IFACE=$(ip route | grep default | awk '{print $5}' | head -1)

if [ -z "$INET_IFACE" ]; then
    echo "Error: No interface with a default route found." >&2
    exit 1
fi

# Kubernetes adapter: the second interface (not loopback, not the internet one)
K8S_IFACE=$(ip -o link show | awk -F': ' '{print $2}' | grep -v "^lo$" | grep -v "^$INET_IFACE$" | head -1)

if [ -z "$K8S_IFACE" ]; then
    echo "Error: No second network adapter found." >&2
    echo "Make sure you have added a second adapter to the VM." >&2
    exit 1
fi

echo "=== Detected Interfaces ==="
echo "  Internet (DHCP):     $INET_IFACE"
echo "  Kubernetes (Static): $K8S_IFACE -> $STATIC_IP/$SUBNET_PREFIX"
echo ""

# --- Remove any old conflicting netplan config ---
if [ -f /etc/netplan/01-static-k8s.yaml ]; then
    echo "Removing old netplan config..."
    sudo rm -f /etc/netplan/01-static-k8s.yaml
fi

# --- Create Netplan configuration for the Kubernetes adapter only ---
sudo tee /etc/netplan/50-k8s-static.yaml > /dev/null <<EOF
network:
  version: 2
  renderer: networkd
  ethernets:
    $K8S_IFACE:
      dhcp4: false
      addresses:
        - $STATIC_IP/$SUBNET_PREFIX
      routes:
        - to: $K8S_NETWORK
          via: $K8S_GATEWAY
      nameservers:
        addresses:
          - 8.8.8.8
          - 8.8.4.4
EOF

# Restrict permissions (netplan warns if config is world-readable)
sudo chmod 600 /etc/netplan/50-k8s-static.yaml

echo "Applying netplan configuration..."
sudo netplan apply

echo ""
echo "=== Network Configuration ==="
echo "--- $INET_IFACE (Internet) ---"
ip -4 addr show "$INET_IFACE" | grep inet
echo ""
echo "--- $K8S_IFACE (Kubernetes) ---"
ip -4 addr show "$K8S_IFACE" | grep inet
echo ""

echo "Internet test:"
ping -c 1 -W 3 8.8.8.8 > /dev/null 2>&1 && echo "  ✅ Internet is working" || echo "  ❌ No internet"
echo ""
echo "Kubernetes IP test:"
ping -c 1 -W 3 "$STATIC_IP" > /dev/null 2>&1 && echo "  ✅ $STATIC_IP is reachable" || echo "  ❌ $STATIC_IP not responding"
echo ""
echo "Done! Kubernetes adapter ($K8S_IFACE) configured with $STATIC_IP/$SUBNET_PREFIX."

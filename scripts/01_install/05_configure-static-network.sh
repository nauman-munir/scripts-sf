#!/bin/bash

# =============================================================================
# 05_configure-static-network.sh
# Single interface setup with two IPs:
#   - DHCP: Keeps internet access (auto-assigned IP from router)
#   - Static: Adds 10.10.10.10 for Kubernetes
#
# Both IPs live on the same network adapter. No second adapter required.
# =============================================================================

STATIC_IP="10.10.10.10"
SUBNET_PREFIX="21"

# Detect the active interface (the one with the default route)
INTERFACE=$(ip route | grep default | awk '{print $5}' | head -1)

if [ -z "$INTERFACE" ]; then
    echo "Error: No interface with a default route found." >&2
    exit 1
fi

echo "Interface: $INTERFACE"
echo "  DHCP:   enabled (internet)"
echo "  Static: $STATIC_IP/$SUBNET_PREFIX (Kubernetes)"
echo ""

# Create Netplan configuration — DHCP + Static on the same interface
sudo tee /etc/netplan/01-static-k8s.yaml > /dev/null <<EOF
network:
  version: 2
  renderer: networkd
  ethernets:
    $INTERFACE:
      dhcp4: true
      addresses:
        - $STATIC_IP/$SUBNET_PREFIX
      nameservers:
        addresses:
          - 8.8.8.8
          - 8.8.4.4
EOF

echo "Applying netplan configuration..."
sudo netplan apply

echo ""
echo "=== Network Configuration ==="
ip -4 addr show "$INTERFACE" | grep inet
echo ""
echo "Internet test:"
ping -c 1 -W 3 8.8.8.8 > /dev/null 2>&1 && echo "  ✅ Internet is working" || echo "  ❌ No internet"
echo ""
echo "Kubernetes IP test:"
ping -c 1 -W 3 $STATIC_IP > /dev/null 2>&1 && echo "  ✅ $STATIC_IP is reachable" || echo "  ❌ $STATIC_IP not responding"
echo ""
echo "Done! Your interface now has both IPs."

#!/bin/bash

# =============================================================================
# 05_configure-static-network.sh
# Dual interface setup:
#   - Interface 1 (NAT/Bridged): DHCP for internet access
#   - Interface 2 (Host-Only):   Static IP for Kubernetes (10.10.10.10)
#
# PREREQUISITE:
#   Add a second network adapter to your VM before running:
#     VirtualBox: Settings → Network → Adapter 2 → Enable → Host-Only Adapter
#     VMware:     Settings → Add → Network Adapter → Host-Only
#   Then reboot the VM so the interface appears.
# =============================================================================

STATIC_IP="10.10.10.10"
SUBNET_PREFIX="21"

# Detect the primary interface (the one with internet / default route)
PRIMARY_IF=$(ip route | grep default | awk '{print $5}' | head -1)

if [ -z "$PRIMARY_IF" ]; then
    echo "Error: No primary interface with a default route found." >&2
    exit 1
fi

# Detect the secondary interface (any interface that is NOT the primary and NOT loopback)
SECONDARY_IF=$(ip -o link show | awk -F': ' '{print $2}' | grep -v "lo" | grep -v "$PRIMARY_IF" | head -1)

if [ -z "$SECONDARY_IF" ]; then
    echo "Error: No secondary interface found." >&2
    echo "" >&2
    echo "You need to add a second network adapter to your VM:" >&2
    echo "  VirtualBox: Settings → Network → Adapter 2 → Enable → Host-Only Adapter" >&2
    echo "  VMware:     Settings → Add → Network Adapter → Host-Only" >&2
    echo "" >&2
    echo "Then reboot and run this script again." >&2
    exit 1
fi

echo "Primary interface (internet):    $PRIMARY_IF (DHCP – unchanged)"
echo "Secondary interface (Kubernetes): $SECONDARY_IF (Static – $STATIC_IP/$SUBNET_PREFIX)"
echo ""

# Create Netplan configuration — two interfaces
sudo tee /etc/netplan/01-static-k8s.yaml > /dev/null <<EOF
network:
  version: 2
  renderer: networkd
  ethernets:
    $PRIMARY_IF:
      dhcp4: true
    $SECONDARY_IF:
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
echo ""
echo "Interface: $PRIMARY_IF (Internet)"
ip -4 addr show "$PRIMARY_IF" | grep inet
echo ""
echo "Interface: $SECONDARY_IF (Kubernetes)"
ip -4 addr show "$SECONDARY_IF" | grep inet
echo ""
echo "Internet test:"
ping -c 1 -W 3 8.8.8.8 > /dev/null 2>&1 && echo "  ✅ Internet is working" || echo "  ❌ No internet (check $PRIMARY_IF)"
echo ""
echo "Done! Kubernetes should bind to $STATIC_IP"

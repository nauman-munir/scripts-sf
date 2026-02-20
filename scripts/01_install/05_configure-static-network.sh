#!/bin/bash

STATIC_IP="10.10.10.10"
NETMASK="255.255.248.0"
GATEWAY="10.10.10.1"
INTERFACE=$(ip route | grep default | awk '{print $5}' | head -1)

echo "Configuring static network on interface: $INTERFACE"
echo "Static IP: $STATIC_IP"

# Create Netplan configuration for static IP
sudo tee /etc/netplan/01-static-k8s.yaml > /dev/null <<EOF
network:
  version: 2
  renderer: networkd
  ethernets:
    $INTERFACE:
      addresses:
        - $STATIC_IP/21
      routes:
        - to: default
          via: $GATEWAY
      nameservers:
        addresses:
          - 8.8.8.8
          - 8.8.4.4
EOF

echo "Applying netplan configuration..."
sudo netplan apply

echo "Static network configured on $STATIC_IP"
ip addr show $INTERFACE

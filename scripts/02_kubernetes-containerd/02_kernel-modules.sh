#!/bin/bash

echo "Applying recommended kernel modifications for Kubernetes..."

# Load required kernel modules
sudo tee /etc/modules-load.d/k8s.conf > /dev/null <<EOF
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Set required sysctl parameters (persist across reboots)
sudo tee /etc/sysctl.d/k8s.conf > /dev/null <<EOF
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl parameters without reboot
sudo sysctl --system

echo "Verifying kernel modules..."
lsmod | grep -E "overlay|br_netfilter"

echo "Kernel modifications applied successfully."

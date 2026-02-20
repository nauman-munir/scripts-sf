#!/bin/bash

echo "Disabling swap (Required for Kubernetes)..."

# Disable swap immediately
sudo swapoff -a

# Remove swap entries from /etc/fstab to persist across reboots
sudo sed -i '/ swap / s/^/#/' /etc/fstab
sudo sed -i '/swap/s/^/#/' /etc/fstab

echo "Swap status (should be empty):"
free -h | grep -i swap

echo "Swap has been disabled."

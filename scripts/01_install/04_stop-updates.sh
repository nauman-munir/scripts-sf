#!/bin/bash

echo "Preventing OS/Kernel package updates..."

# Hold kernel packages to prevent unwanted updates
sudo apt-mark hold linux-image-generic linux-headers-generic linux-generic

# Disable unattended upgrades
sudo systemctl stop unattended-upgrades 2>/dev/null
sudo systemctl disable unattended-upgrades 2>/dev/null

# Disable automatic updates via apt config
sudo tee /etc/apt/apt.conf.d/20auto-upgrades > /dev/null <<EOF
APT::Periodic::Update-Package-Lists "0";
APT::Periodic::Unattended-Upgrade "0";
APT::Periodic::AutocleanInterval "0";
APT::Periodic::Download-Upgradeable-Packages "0";
EOF

echo "Held packages:"
apt-mark showhold

echo "OS/Kernel updates have been disabled."

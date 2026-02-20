#!/bin/bash

NFS_SHARE="/srv/nfs/semafor"
SUBNET="10.10.10.0/21"

echo "Configuring local NFS share at $NFS_SHARE..."

# Install NFS server
sudo apt-get update
sudo apt-get install -y nfs-kernel-server

# Create NFS share directory
sudo mkdir -p $NFS_SHARE
sudo chown nobody:nogroup $NFS_SHARE
sudo chmod 777 $NFS_SHARE

# Add export entry if not already present
if ! grep -q "$NFS_SHARE" /etc/exports; then
    echo "$NFS_SHARE $SUBNET(rw,sync,no_subtree_check,no_root_squash)" | sudo tee -a /etc/exports
else
    echo "NFS export already configured."
fi

# Apply exports and restart NFS
sudo exportfs -ra
sudo systemctl restart nfs-kernel-server
sudo systemctl enable nfs-kernel-server

echo "NFS exports:"
sudo exportfs -v

echo "NFS share configured at $NFS_SHARE."

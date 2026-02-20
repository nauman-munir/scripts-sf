#!/bin/bash

MOUNT_POINT="/mnt/ramdisk"

echo "Creating 1GB RAM Disk mount point at $MOUNT_POINT..."
sudo mkdir -p $MOUNT_POINT

# Add to /etc/fstab for persistence with 1G size
if ! grep -q "$MOUNT_POINT" /etc/fstab; then
    echo "Adding 1GB RAM Disk entry to /etc/fstab..."
    echo "tmpfs $MOUNT_POINT tmpfs nodev,nosuid,noexec,nodiratime,size=1G 0 0" | sudo tee -a /etc/fstab
else
    echo "Updating existing RAM Disk entry to 1G..."
    sudo sed -i "s|tmpfs $MOUNT_POINT tmpfs.*|tmpfs $MOUNT_POINT tmpfs nodev,nosuid,noexec,nodiratime,size=1G 0 0|" /etc/fstab
fi

echo "Remounting..."
sudo mount -a

echo "RAM Disk is ready. Size:"
df -h $MOUNT_POINT

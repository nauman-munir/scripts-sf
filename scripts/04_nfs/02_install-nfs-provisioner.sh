#!/bin/bash

NFS_SERVER="10.10.10.10"
NFS_PATH="/srv/nfs/semafor"

echo "Installing NFS Subdir External Provisioner via Helm..."

# Add the NFS provisioner Helm repo
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
helm repo update

# Install the NFS provisioner
helm install nfs-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --namespace kube-system \
    --set nfs.server=$NFS_SERVER \
    --set nfs.path=$NFS_PATH \
    --set storageClass.name=nfs-client \
    --set storageClass.defaultClass=true

echo "NFS Provisioner status:"
kubectl -n kube-system get pods -l app=nfs-subdir-external-provisioner

echo "Storage classes:"
kubectl get storageclass

echo "NFS Provisioner installed."

#!/bin/bash

echo "Updating system package lists..."
sudo apt-get update

echo "Installing Linux utilities and services..."
# Essential tools for K8s, networking, and script execution
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    net-tools \
    vim \
    git \
    wget \
    software-properties-common \
    nfs-common \
    conky-all

echo "Package installation complete!"

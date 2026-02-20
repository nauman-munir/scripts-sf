#!/bin/bash

echo "Installing Docker CE..."

sudo apt-get update
sudo apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

# Enable and start Docker
sudo systemctl enable docker
sudo systemctl start docker

echo "Docker version:"
docker --version

echo "Docker CE installed successfully."

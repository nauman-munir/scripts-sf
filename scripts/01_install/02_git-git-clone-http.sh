#!/bin/bash

echo "Cloning additional troubleshooting & Helm repos..."

CLONE_DIR="$HOME/repos"
mkdir -p "$CLONE_DIR"
cd "$CLONE_DIR"

# Clone Helm charts repository
if [ ! -d "$CLONE_DIR/helm-charts" ]; then
    echo "Cloning helm-charts..."
    git clone https://github.com/helm/charts.git helm-charts
else
    echo "helm-charts already exists, pulling latest..."
    cd helm-charts && git pull && cd ..
fi

# Clone troubleshooting tools
if [ ! -d "$CLONE_DIR/troubleshooting" ]; then
    echo "Cloning troubleshooting tools..."
    git clone https://github.com/semafor/troubleshooting.git troubleshooting
else
    echo "troubleshooting already exists, pulling latest..."
    cd troubleshooting && git pull && cd ..
fi

echo "Repository cloning complete!"

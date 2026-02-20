#!/bin/bash

USER="semafor"

echo "Adding $USER to the docker group..."

sudo usermod -aG docker $USER

echo "Docker group members:"
getent group docker

echo "$USER added to docker group."
echo "Please log out and back in (or run 'newgrp docker') for changes to take effect."

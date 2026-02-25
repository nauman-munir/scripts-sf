#!/bin/bash

echo "Configuring apt for the Twuni Docker Registry repository..."

# Add the Twuni Helm repo
helm repo add twuni https://twuni.github.io/docker-registry.helm
helm repo update

echo "Helm repos:"
helm repo list

echo "Twuni Helm repository added."

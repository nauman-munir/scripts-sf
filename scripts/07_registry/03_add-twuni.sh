#!/bin/bash

echo "Configuring apt for the Twuni Docker Registry repository..."

# Add the Twuni Helm repo
helm repo add twuni https://helm.twun.io
helm repo update

echo "Helm repos:"
helm repo list

echo "Twuni Helm repository added."

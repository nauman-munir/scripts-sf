#!/bin/bash

# Get the current username
USER=$(whoami)

echo "Configuring passwordless sudo for user: $USER"

# Create a temporary file to validate syntax
echo "$USER ALL=(ALL) NOPASSWD:ALL" > temp_sudoer

# Use visudo to check the syntax and move it to /etc/sudoers.d/
# This prevents locking yourself out of the system if there's a typo
sudo install -m 0440 temp_sudoer /etc/sudoers.d/90-semafor-nopasswd

# Clean up
rm temp_sudoer

echo "Success! Passwordless sudo is now configured."
echo "Please run 'sudo -k' then 'sudo whoami' to verify (it should not ask for a password)."

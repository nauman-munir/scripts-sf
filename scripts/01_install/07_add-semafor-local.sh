#!/bin/bash

HOSTNAME="semafor.local"
IP="10.10.10.10"

echo "Defining $HOSTNAME as $IP in /etc/hosts..."

# Check if entry already exists
if grep -q "$HOSTNAME" /etc/hosts; then
    echo "Entry already exists, updating..."
    sudo sed -i "s/.*$HOSTNAME.*/$IP $HOSTNAME/" /etc/hosts
else
    echo "Adding new entry..."
    echo "$IP $HOSTNAME" | sudo tee -a /etc/hosts
fi

echo "Current /etc/hosts entry:"
grep "$HOSTNAME" /etc/hosts

echo "semafor.local has been configured."

#!/bin/bash

NETWORK="10.10.10.0/21"
GATEWAY="10.10.10.1"
INTERFACE=$(ip route | grep default | awk '{print $5}' | head -1)

echo "Creating default route to static network..."
echo "Network: $NETWORK via Gateway: $GATEWAY on Interface: $INTERFACE"

# Add the route
sudo ip route add $NETWORK via $GATEWAY dev $INTERFACE 2>/dev/null || \
    echo "Route may already exist, checking..."

# Make route persistent via netplan or rc.local
if [ ! -f /etc/rc.local ]; then
    sudo tee /etc/rc.local > /dev/null <<EOF
#!/bin/bash
ip route add $NETWORK via $GATEWAY dev $INTERFACE 2>/dev/null
exit 0
EOF
    sudo chmod +x /etc/rc.local
fi

echo "Current routing table:"
ip route show

echo "Default route to static network configured."

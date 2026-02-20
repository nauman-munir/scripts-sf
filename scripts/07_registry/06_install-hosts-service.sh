#!/bin/bash

SERVICE_NAME="twuni-hosts-update"
NAMESPACE="twuni"

echo "Creating service to update Twuni registry IP in /etc/hosts..."

# Create the update script
sudo tee /usr/local/bin/update-twuni-hosts.sh > /dev/null <<'SCRIPT'
#!/bin/bash
# Updates /etc/hosts with the current Twuni registry pod IP

REGISTRY_IP=$(kubectl -n twuni get pod -l app=docker-registry -o jsonpath='{.items[0].status.podIP}' 2>/dev/null)

if [ -n "$REGISTRY_IP" ]; then
    HOSTNAME="twuni-registry.local"
    # Remove old entry
    sudo sed -i "/$HOSTNAME/d" /etc/hosts
    # Add new entry
    echo "$REGISTRY_IP $HOSTNAME" | sudo tee -a /etc/hosts > /dev/null
    echo "$(date) - Updated $HOSTNAME to $REGISTRY_IP"
fi
SCRIPT

sudo chmod +x /usr/local/bin/update-twuni-hosts.sh

# Create systemd service
sudo tee /etc/systemd/system/$SERVICE_NAME.service > /dev/null <<EOF
[Unit]
Description=Update Twuni Registry IP in /etc/hosts
After=network-online.target kubelet.service
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/update-twuni-hosts.sh
EOF

# Create a timer to run periodically
sudo tee /etc/systemd/system/$SERVICE_NAME.timer > /dev/null <<EOF
[Unit]
Description=Run Twuni hosts update every 5 minutes

[Timer]
OnBootSec=60
OnUnitActiveSec=300

[Install]
WantedBy=timers.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable $SERVICE_NAME.timer
sudo systemctl start $SERVICE_NAME.timer

echo "Twuni hosts update service and timer created."
echo "Timer status:"
sudo systemctl status $SERVICE_NAME.timer --no-pager

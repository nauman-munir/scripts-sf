#!/bin/bash

SERVICE_NAME="semafor-boot"

echo "Creating custom boot service to bring SemaFor online after shutdown..."

# Create the boot script
sudo tee /usr/local/bin/semafor-boot.sh > /dev/null <<'SCRIPT'
#!/bin/bash
# SemaFor Custom Boot Script
# Waits for Kubernetes to be ready and ensures all services are running

LOG="/var/log/semafor-boot.log"

echo "$(date) - SemaFor boot script started" >> $LOG

# Wait for kubelet to be running
echo "$(date) - Waiting for kubelet..." >> $LOG
until systemctl is-active --quiet kubelet; do
    sleep 5
done
echo "$(date) - kubelet is running" >> $LOG

# Wait for Kubernetes API server
echo "$(date) - Waiting for Kubernetes API..." >> $LOG
until kubectl --kubeconfig=/etc/kubernetes/admin.conf get nodes &>/dev/null; do
    sleep 5
done
echo "$(date) - Kubernetes API is ready" >> $LOG

echo "$(date) - SemaFor boot sequence complete" >> $LOG
SCRIPT

sudo chmod +x /usr/local/bin/semafor-boot.sh

# Create the systemd service
sudo tee /etc/systemd/system/$SERVICE_NAME.service > /dev/null <<EOF
[Unit]
Description=SemaFor Custom Boot Service
After=network-online.target kubelet.service
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/semafor-boot.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

# Enable the service
sudo systemctl daemon-reload
sudo systemctl enable $SERVICE_NAME.service

echo "Custom boot service '$SERVICE_NAME' created and enabled."
echo "It will run automatically on next boot."

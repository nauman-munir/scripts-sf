#!/bin/bash

# =============================================================================
# install-helm.sh
# Installs the latest version of Helm using the official script.
# =============================================================================

echo "Installing Helm..."

# Download and run the official Helm installation script
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Verify installation
if command -v helm &> /dev/null; then
    echo "✅ Helm installed successfully:"
    helm version
else
    echo "❌ Helm installation failed." >&2
    exit 1
fi

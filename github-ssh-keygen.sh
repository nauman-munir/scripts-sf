#!/bin/bash

# GitHub SSH Key Generator
# Generates an ED25519 SSH key pair and configures it for GitHub

set -e

read -rp "Enter your GitHub email: " EMAIL

if [ -z "$EMAIL" ]; then
    echo "Error: Email cannot be empty."
    exit 1
fi

KEY_FILE="$HOME/.ssh/id_ed25519_github"

# Create .ssh directory if it doesn't exist
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

# Generate SSH key
echo "Generating SSH key..."
ssh-keygen -t ed25519 -C "$EMAIL" -f "$KEY_FILE" -N ""

# Start ssh-agent and add key
eval "$(ssh-agent -s)"
ssh-add "$KEY_FILE"

# Configure SSH to use this key for GitHub
if ! grep -q "Host github.com" "$HOME/.ssh/config" 2>/dev/null; then
    cat >> "$HOME/.ssh/config" <<EOF

Host github.com
    HostName github.com
    User git
    IdentityFile $KEY_FILE
    IdentitiesOnly yes
EOF
    chmod 600 "$HOME/.ssh/config"
    echo "SSH config updated."
fi

echo ""
echo "========================================="
echo "  SSH key generated successfully!"
echo "========================================="
echo ""
echo "Public key (copy this to GitHub -> Settings -> SSH Keys):"
echo ""
cat "${KEY_FILE}.pub"
echo ""
echo "Or copy with: cat ${KEY_FILE}.pub | xclip -selection clipboard"
echo ""
echo "GitHub SSH keys page: https://github.com/settings/keys"

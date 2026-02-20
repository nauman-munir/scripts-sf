#!/bin/bash

# SemaFor image list — Run this first before subsequent scripts
# This script defines the images used by SemaFor

echo "Defining SemaFor image list..."

export SEMAFOR_IMAGES=(
    # Add your SemaFor application images here
    # Example:
    # "semafor.local:30500/semafor/app:latest"
    # "semafor.local:30500/semafor/worker:latest"
)

IMAGES_FILE="$HOME/.semafor-images"

# Write the image list to a file for use by other scripts
cat > "$IMAGES_FILE" <<'EOF'
# SemaFor Docker Images
# Add one image per line (without comments)
# Example:
# semafor.local:30500/semafor/app:latest
# semafor.local:30500/semafor/worker:latest
EOF

echo "Image list file created at: $IMAGES_FILE"
echo "Edit $IMAGES_FILE to add your SemaFor images before running subsequent scripts."
echo ""
echo "Current image list:"
cat "$IMAGES_FILE"

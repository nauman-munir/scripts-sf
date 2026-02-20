#!/bin/bash

IMAGES_FILE="$HOME/.semafor-images"
BACKUP_DIR="$HOME/image-backups"

echo "Exporting Kubernetes images to .tar backup..."

mkdir -p "$BACKUP_DIR"

if [ ! -f "$IMAGES_FILE" ]; then
    echo "ERROR: Image list not found at $IMAGES_FILE"
    echo "Run 01_semafor-images.sh first."
    exit 1
fi

# Export each image
while IFS= read -r IMAGE; do
    # Skip comments and empty lines
    [[ "$IMAGE" =~ ^#.*$ || -z "$IMAGE" ]] && continue

    FILENAME=$(echo "$IMAGE" | sed 's/[\/:]/_/g').tar
    echo "Exporting: $IMAGE -> $BACKUP_DIR/$FILENAME"

    sudo ctr -n k8s.io images export "$BACKUP_DIR/$FILENAME" "$IMAGE" 2>/dev/null || \
        echo "  WARNING: Failed to export $IMAGE (may not exist in containerd)"
done < "$IMAGES_FILE"

echo ""
echo "Exported images:"
ls -lh "$BACKUP_DIR"/*.tar 2>/dev/null || echo "No images exported."

echo "Image export complete."

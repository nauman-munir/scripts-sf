#!/bin/bash

IMAGES_FILE="$HOME/.semafor-images"
REGISTRY="semafor.local:30500"

echo "Copying Docker images to Twuni registry at $REGISTRY..."

if [ ! -f "$IMAGES_FILE" ]; then
    echo "ERROR: Image list not found at $IMAGES_FILE"
    echo "Run 01_semafor-images.sh first."
    exit 1
fi

while IFS= read -r IMAGE; do
    # Skip comments and empty lines
    [[ "$IMAGE" =~ ^#.*$ || -z "$IMAGE" ]] && continue

    # Get image name without registry prefix
    IMAGE_NAME=$(echo "$IMAGE" | sed "s|.*/||")
    TARGET="$REGISTRY/$IMAGE_NAME"

    echo "Tagging: $IMAGE -> $TARGET"
    sudo docker tag "$IMAGE" "$TARGET" 2>/dev/null || \
        echo "  WARNING: Failed to tag $IMAGE"

    echo "Pushing: $TARGET"
    sudo docker push "$TARGET" 2>/dev/null || \
        echo "  WARNING: Failed to push $TARGET"
done < "$IMAGES_FILE"

echo ""
echo "Registry catalog:"
curl -s http://$REGISTRY/v2/_catalog 2>/dev/null | python3 -m json.tool || echo "Could not reach registry"

echo "Image copy to Twuni registry complete."

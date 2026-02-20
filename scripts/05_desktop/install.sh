#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DESKTOP_DIR="$HOME/Desktop"
ICONS_DIR="$SCRIPT_DIR/icons"

echo "Copying desktop icons to $DESKTOP_DIR..."

# Create Desktop directory if it doesn't exist
mkdir -p "$DESKTOP_DIR"

# Copy all .desktop files from the icons directory
if [ -d "$ICONS_DIR" ]; then
    cp -v "$ICONS_DIR"/*.desktop "$DESKTOP_DIR/" 2>/dev/null || echo "No .desktop files found in $ICONS_DIR"
else
    echo "Icons directory not found at $ICONS_DIR"
    echo "Please create the icons directory with .desktop files first."
    exit 1
fi

echo ""
echo "Desktop icons copied."
echo "MANUAL STEP: Right-click icons with red 'X' and select 'Allow Launching'"

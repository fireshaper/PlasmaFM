#!/bin/bash

# Roam Radio - Development Installation Script
# Reinstalls the plasmoid for testing (removes old version first)

WIDGET_NAME="org.kde.plasma.roamradio"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Development install: Reinstalling Roam Radio plasmoid..."

# Detect which package tool is available
if command -v kpackagetool6 &> /dev/null; then
    PKGTOOL="kpackagetool6"
    echo "Using kpackagetool6 (Plasma 6)"
elif command -v plasmapkg2 &> /dev/null; then
    PKGTOOL="plasmapkg2"
    echo "Using plasmapkg2 (Plasma 5)"
else
    echo "Error: Neither kpackagetool6 nor plasmapkg2 found."
    echo "Please install kf6-kpackage or plasma-framework."
    exit 1
fi

# Remove existing installation
if $PKGTOOL --type Plasma/Applet --list 2>/dev/null | grep -q "$WIDGET_NAME"; then
    echo "Removing existing installation..."
    $PKGTOOL --type Plasma/Applet --remove "$WIDGET_NAME"
fi

# Also check and remove from generic location
if $PKGTOOL --list 2>/dev/null | grep -q "$WIDGET_NAME"; then
    echo "Removing from generic location..."
    $PKGTOOL --remove "$WIDGET_NAME" 2>/dev/null || true
fi

# Install the widget with correct type
echo "Installing widget from $SCRIPT_DIR..."
$PKGTOOL --type Plasma/Applet --install "$SCRIPT_DIR"

if [ $? -eq 0 ]; then
    echo "✓ Roam Radio reinstalled successfully!"
    echo ""
    echo "Restarting plasmashell to reload widget..."
    killall plasmashell
    sleep 1
    kstart plasmashell &
    echo "✓ Plasmashell restarted"
    echo ""
    echo "You can now test the updated widget."
else
    echo "✗ Installation failed!"
    exit 1
fi

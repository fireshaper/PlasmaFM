#!/bin/bash

# Roam Radio - Installation Script
# Installs the plasmoid to the local Plasma widgets directory

WIDGET_NAME="org.kde.plasma.roamradio"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing Roam Radio plasmoid..."

# Detect which package tool is available
if command -v kpackagetool6 &> /dev/null; then
    PKGTOOL="kpackagetool6"
    echo "Using kpackagetool6 (Plasma 6)"
elif command -v plasmapkg2 &> /dev/null; then
    PKGTOOL="plasmapkg2"
    echo "Using plasmapkg2 (Plasma 5)"
else
    echo "Error: Neither kpackagetool6 nor plasmapkg2 found."
    echo ""
    echo "Please install one of the following packages:"
    echo "  Fedora/RHEL: sudo dnf install kf6-kpackage"
    echo "  Ubuntu/Debian: sudo apt install plasma-framework"
    echo "  Arch: sudo pacman -S plasma-framework"
    exit 1
fi

# Remove existing installation if present
if $PKGTOOL --type Plasma/Applet --list 2>/dev/null | grep -q "$WIDGET_NAME"; then
    echo "Removing existing installation..."
    $PKGTOOL --type Plasma/Applet --remove "$WIDGET_NAME"
fi

# Also check and remove from generic location (in case it was installed there)
if $PKGTOOL --list 2>/dev/null | grep -q "$WIDGET_NAME"; then
    echo "Removing from generic location..."
    $PKGTOOL --remove "$WIDGET_NAME" 2>/dev/null || true
fi

# Install the widget with correct type
echo "Installing widget from $SCRIPT_DIR..."
$PKGTOOL --type Plasma/Applet --install "$SCRIPT_DIR"

if [ $? -eq 0 ]; then
    echo "✓ Roam Radio installed successfully!"
    echo ""
    echo "To add the widget:"
    echo "1. Right-click on your desktop or panel"
    echo "2. Select 'Add Widgets...'"
    echo "3. Search for 'Roam Radio'"
    echo "4. Drag it to your desktop or panel"
    echo ""
    echo "To restart plasmashell (if needed):"
    echo "  killall plasmashell; kstart plasmashell"
else
    echo "✗ Installation failed!"
    exit 1
fi

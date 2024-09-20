#!/bin/bash

set -e

REPO="abes140377/yade-project-generator-cli"  # Ersetze das mit deinem GitHub Repository

# Hole die neueste Release-Version
LATEST_RELEASE=$(curl --silent "https://api.github.com/repos/$REPO/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

# Download der neuesten Version
echo "Downloading latest release: $LATEST_RELEASE"
curl -L "https://github.com/$REPO/releases/download/$LATEST_RELEASE/yade" -o /usr/local/bin/yade

# Setze Ausführungsrechte
chmod +x /usr/local/bin/yade

echo "Installation complete! Run 'yade' to start."

#!/bin/bash

set -e

REPO="abes140377/yade-generator-cli"  # Ersetze das mit deinem GitHub Repository

# Hole die neueste Release-Version
LATEST_RELEASE=$(curl --silent "https://api.github.com/repos/$REPO/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

cat << "EOF"
__  _____    ____  ______   ________    ____
\ \/ /   |  / __ \/ ____/  / ____/ /   /  _/
 \  / /| | / / / / __/    / /   / /    / /  
 / / ___ |/ /_/ / /___   / /___/ /____/ /   
/_/_/  |_/_____/_____/   \____/_____/___/   
EOF

echo "YADE CLI Installer $LATEST_RELEASE"
echo ""

# Download der neuesten Version
echo "Downloading binary to /usr/local/bin/yade..."
curl -s -L "https://github.com/$REPO/releases/download/$LATEST_RELEASE/yade" -o /usr/local/bin/yade

# Setze Ausführungsrechte
echo "Change permissions..."
chmod +x /usr/local/bin/yade

echo ""
echo "Installation complete! Run 'yade' to start."
echo ""

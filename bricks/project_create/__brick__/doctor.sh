#!/bin/bash

# Name des zu prüfenden Datei
file=".env.private"

clear

cat << "EOF"
__  _____    ____  ______   ____             __            
\ \/ /   |  / __ \/ ____/  / __ \____  _____/ /_____  _____
 \  / /| | / / / / __/    / / / / __ \/ ___/ __/ __ \/ ___/
 / / ___ |/ /_/ / /___   / /_/ / /_/ / /__/ /_/ /_/ / /    
/_/_/  |_/_____/_____/  /_____/\____/\___/\__/\____/_/     

Checking Pre-conditions for {{organization.upperCase()}} {{applicationName.upperCase()}} {{environment.upperCase()}}

EOF

# Überprüfen, ob die Datei existiert
if [[ -f "$file" ]]; then
    echo "✔ The file '$file' exists."
    
    # Überprüfen, ob die Datei die Zeichenkette <server>:<port> enthält
    if grep -q "<server>:<port>" "$file"; then
        echo ""
        echo "⚠ Error:"
        echo "The file '$file' still contains the placeholder '<server>:<port>'."
        echo "Please replace this value with a valid Vault host and port."
        echo ""
        exit 1
    fi

    # Überprüfen, ob die Datei die Zeichenkette <vault_token> enthält
    if grep -q "<vault_token>" "$file"; then
        echo ""
        echo "⚠ Error:"
        echo "The file '$file' still contains the placeholder '<vault_token>'."
        echo "Please replace this value with a valid Vault token."
        echo ""
        exit 1
    fi

    echo "✔ The placeholders in the file '$file' have been replaced."
else
    echo ""
    echo "⚠ Error:"
    echo "The file '$file' does not exist in the current directory."
    echo "Make a copy of the template .env.private.example and replace the placeholders with the corresponding values."
    echo ""
    exit 1
fi

echo ""
echo "You can now start one of the environments. Example:"
echo ""
echo "  task matrix:install:sbox"
echo ""

exit 0
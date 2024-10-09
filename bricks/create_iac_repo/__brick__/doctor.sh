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

Checking Pre-conditions for {{organization.upperCase()}} {{applicationName.pascalCase()}} {{environment.pascalCase()}}

EOF

# Überprüfen, ob die Datei existiert
if [[ -f "$file" ]]; then
    echo "✔ Die Datei '$file' existiert."
    
    # Überprüfen, ob die Datei die Zeichenkette <server>:<port> enthält
    if grep -q "<server>:<port>" "$file"; then
        echo ""
        echo "⚠ Fehler: In der Datei '$file' befindet sich noch der Platzhalter '<server>:<port>'."
        echo "Bitte ersetze diesen Wert durch einen gültigen Vault Host und Port."
        echo ""
        exit 1
    fi

    # Überprüfen, ob die Datei die Zeichenkette <vault_token> enthält
    if grep -q "<vault_token>" "$file"; then
        echo ""
        echo "⚠ Fehler: In der Datei '$file' befindet sich noch der Platzhalter '<vault_token>'."
        echo "Bitte ersetze diesen Wert durch ein gültiges Vault-Token."
        echo ""
        echo ""
        exit 1
    fi

    echo "✔ Die Platzhalter in der Datei '$file' wurden ersetzt."
else
    echo "⚠ Fehler: Die Datei '$file' existiert nicht im aktuellen Verzeichnis."
    echo "   Mach dir eine Kopie der Vorlage .env.private.example und ersetze die Platzhalter mit den entsprechenden Werten."
    echo ""
    exit 1
fi

echo ""
echo "Du kannst jetzt eine der Umgebungen starten."
echo "Bsp.:"
echo "  task example:install:sbox"
echo ""

exit 0
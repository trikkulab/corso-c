#!/bin/bash
# Installa il compilatore C (Xcode Command Line Tools) e le estensioni di VS Code.
#
# Uso, dal Terminale nella cartella Corso-C:
#   bash setup/setup-mac.sh

echo "== 1/2 Strumenti di sviluppo Apple (clang, lldb) =="
if xcode-select -p >/dev/null 2>&1; then
    echo "Già installati."
else
    xcode-select --install
    echo
    echo "Completa l'installazione nella finestra che si è aperta,"
    echo "poi rilancia questo script."
    exit 0
fi

PROFILO="Corso Info"
CORSO="$(cd "$(dirname "$0")/.." && pwd)"

echo "== 2/2 Profilo VS Code \"$PROFILO\" con le estensioni =="
if command -v code >/dev/null 2>&1; then
    # Il profilo viene creato solo aprendo VS Code: da riga di comando non si possono
    # installare estensioni in un profilo che non esiste ancora.
    echo "Apro VS Code sulla cartella Corso-C nel profilo \"$PROFILO\"..."
    code --profile "$PROFILO" "$CORSO"
    for attesa in $(seq 1 60); do
        code --profile "$PROFILO" --list-extensions 2>&1 | grep -qi "not found" || break
        sleep 1
    done
    code --profile "$PROFILO" --install-extension llvm-vs-code-extensions.vscode-clangd
    code --profile "$PROFILO" --install-extension vadimcn.vscode-lldb
else
    echo "Comando 'code' non trovato. In VS Code: Cmd+Shift+P ->"
    echo "  \"Shell Command: Install 'code' command in PATH\", poi rilancia lo script."
    echo "(In alternativa installa le estensioni da VS Code: te le propone aprendo la cartella.)"
fi

echo
clang --version
CLANGD=$(xcrun --find clangd 2>/dev/null)
if [ -n "$CLANGD" ]; then
    echo
    echo "clangd trovato in: $CLANGD"
    echo "Se VS Code chiede di scaricare clangd, puoi invece impostare"
    echo "\"clangd.path\": \"$CLANGD\" nelle impostazioni utente."
fi
echo
echo "Fatto! Se VS Code chiede di ricaricare la finestra, accetta."

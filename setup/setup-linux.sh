#!/bin/bash
# Installa il compilatore C (clang), il debugger, Git e le estensioni di VS Code.
# Funziona su Ubuntu/Debian/Mint, Fedora, Arch/Manjaro e openSUSE.
#
# Uso, dal Terminale nella cartella Corso-C:
#   bash setup/setup-linux.sh

echo "== 1/2 Compilatore, debugger e Git =="
if [ "$(id -u)" -eq 0 ]; then
    SUDO=""
else
    SUDO="sudo"
fi

if command -v apt-get >/dev/null 2>&1; then
    $SUDO apt-get update
    $SUDO apt-get install -y clang lldb git
    # clangd ha un pacchetto a parte; su versioni vecchie di Ubuntu/Debian può mancare
    $SUDO apt-get install -y clangd || echo "Pacchetto clangd non disponibile: lo scarica VS Code."
elif command -v dnf >/dev/null 2>&1; then
    $SUDO dnf install -y clang clang-tools-extra lldb git
elif command -v pacman >/dev/null 2>&1; then
    $SUDO pacman -S --needed --noconfirm clang lldb git
elif command -v zypper >/dev/null 2>&1; then
    $SUDO zypper install -y clang clang-tools lldb git
else
    echo "Distribuzione non riconosciuta."
    echo "Installa a mano i pacchetti: clang, clangd, lldb, git. Poi rilancia lo script."
    exit 1
fi

PROFILO="Corso Info"
CORSO="$(cd "$(dirname "$0")/.." && pwd)"

echo
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
    echo "Comando 'code' non trovato: VS Code non è installato."
    echo "Scaricalo da https://code.visualstudio.com (pacchetto .deb o .rpm) oppure"
    echo "installalo dal gestore di software della tua distribuzione, poi rilancia lo script."
    echo "(In alternativa apri la cartella in VS Code: ti propone le estensioni consigliate.)"
fi

echo
clang --version
if command -v clangd >/dev/null 2>&1; then
    echo "clangd trovato in: $(command -v clangd)"
fi
echo
echo "Fatto! Se VS Code chiede di ricaricare la finestra, accetta."

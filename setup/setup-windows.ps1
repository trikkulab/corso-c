# Installa il compilatore C (llvm-mingw), Git e le estensioni di VS Code.
# Non servono permessi di amministratore.
#
# Uso: tasto destro sul file -> "Esegui con PowerShell"
# oppure da terminale:
#   powershell -ExecutionPolicy Bypass -File setup\setup-windows.ps1

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$dest = Join-Path $env:LOCALAPPDATA "llvm-mingw"

if ($env:PROCESSOR_ARCHITECTURE -eq "ARM64") { $arch = "aarch64" } else { $arch = "x86_64" }

Write-Host "== 1/4 Scarico llvm-mingw ($arch) ==" -ForegroundColor Cyan
$release = Invoke-RestMethod "https://api.github.com/repos/mstorsjo/llvm-mingw/releases/latest"
$asset = $release.assets | Where-Object { $_.name -like "llvm-mingw-*-ucrt-$arch.zip" } | Select-Object -First 1
if ($null -eq $asset) { throw "Non trovo il pacchetto llvm-mingw per $arch" }

$zip = Join-Path $env:TEMP $asset.name
Invoke-WebRequest $asset.browser_download_url -OutFile $zip -UseBasicParsing

Write-Host "== 2/4 Estraggo in $dest ==" -ForegroundColor Cyan
$tmp = Join-Path $env:TEMP "llvm-mingw-extract"
if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force }
Expand-Archive $zip -DestinationPath $tmp
if (Test-Path $dest) { Remove-Item $dest -Recurse -Force }
$inner = Get-ChildItem $tmp -Directory | Select-Object -First 1
Move-Item $inner.FullName $dest
Remove-Item $tmp -Recurse -Force
Remove-Item $zip -Force

$bin = Join-Path $dest "bin"
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($null -eq $userPath) { $userPath = "" }
if (($userPath -split ";") -notcontains $bin) {
    [Environment]::SetEnvironmentVariable("Path", ($userPath.TrimEnd(";") + ";" + $bin), "User")
    Write-Host "Aggiunto $bin al PATH utente"
}
$env:Path = "$env:Path;$bin"

Write-Host "== 3/4 Git ==" -ForegroundColor Cyan
$git = Get-Command git -ErrorAction SilentlyContinue
if ($git) {
    Write-Host "Gia' installato: $($git.Source)"
} else {
    # Versione "portable" ufficiale di Git per Windows: si scompatta nella cartella utente,
    # senza installazione e senza permessi di amministratore
    $gitDest = Join-Path $env:LOCALAPPDATA "PortableGit"
    if ($env:PROCESSOR_ARCHITECTURE -eq "ARM64") { $gitArch = "arm64" } else { $gitArch = "64-bit" }
    $gitRelease = Invoke-RestMethod "https://api.github.com/repos/git-for-windows/git/releases/latest"
    $gitAsset = $gitRelease.assets | Where-Object { $_.name -like "PortableGit-*-$gitArch.7z.exe" } | Select-Object -First 1
    if ($null -eq $gitAsset) { throw "Non trovo Git portable per $gitArch" }

    Write-Host "Scarico $($gitAsset.name)"
    $gitExe = Join-Path $env:TEMP $gitAsset.name
    Invoke-WebRequest $gitAsset.browser_download_url -OutFile $gitExe -UseBasicParsing
    if (Test-Path $gitDest) { Remove-Item $gitDest -Recurse -Force }
    Write-Host "Estraggo in $gitDest (meno di un minuto)..."
    Start-Process $gitExe -ArgumentList "-o`"$gitDest`"", "-y" -Wait
    Remove-Item $gitExe -Force

    $gitCmd = Join-Path $gitDest "cmd"
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($null -eq $userPath) { $userPath = "" }
    if (($userPath -split ";") -notcontains $gitCmd) {
        [Environment]::SetEnvironmentVariable("Path", ($userPath.TrimEnd(";") + ";" + $gitCmd), "User")
        Write-Host "Aggiunto $gitCmd al PATH utente"
    }
    $env:Path = "$env:Path;$gitCmd"

    # Accesso a GitHub con il gestore delle credenziali, senza la finestra di scelta
    git config --system credential.helper manager
    git --version
}

Write-Host "== 4/4 Creo il profilo VS Code 'Corso Info' con le estensioni ==" -ForegroundColor Cyan
$profilo = "Corso Info"
$corso = Split-Path $PSScriptRoot -Parent
$hasCode = [bool](Get-Command code -ErrorAction SilentlyContinue)
if ($hasCode) {
    # Il profilo viene creato solo aprendo VS Code: da riga di comando non si possono
    # installare estensioni in un profilo che non esiste ancora.
    Write-Host "Apro VS Code sulla cartella Corso-C nel profilo '$profilo'..."
    code --profile $profilo $corso

    $estensioni = @("llvm-vs-code-extensions.vscode-clangd", "vadimcn.vscode-lldb")
    $comandoElenco = "code --profile `"$profilo`" --list-extensions 2>&1"
    for ($attesa = 0; $attesa -lt 60; $attesa++) {
        if (-not ((cmd /c $comandoElenco) -match "not found")) { break }
        Start-Sleep -Seconds 1
    }

    foreach ($ext in $estensioni) {
        code --profile $profilo --install-extension $ext
    }

    $presenti = @(cmd /c $comandoElenco)
    $mancanti = @($estensioni | Where-Object { $presenti -notcontains $_ })
    if ($mancanti.Count -gt 0) {
        Write-Host "Non sono riuscito a installare: $($mancanti -join ', '). Installale da VS Code." -ForegroundColor Yellow
    }
} else {
    Write-Host "Comando 'code' non trovato: installa le estensioni da VS Code (te le propone aprendo la cartella)." -ForegroundColor Yellow
}

Write-Host ""
clang --version
Write-Host ""
Write-Host "Fatto! Se VS Code chiede di ricaricare la finestra, accetta." -ForegroundColor Green

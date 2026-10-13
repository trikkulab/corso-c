# Corso di C

Ambiente di lavoro per programmare in C con VS Code, uguale su Windows, Mac e Linux.

## Installazione (una volta sola)

### 1. Installa VS Code
Scaricalo da <https://code.visualstudio.com> e installalo.

### 2. Installa il compilatore e Git

**Windows**
1. Apri la cartella `Corso-C`, poi la cartella `setup`.
2. Doppio clic su **`setup-windows-bat.cmd`**.
   Se compare l'avviso blu "Windows ha protetto il PC", clicca *Ulteriori informazioni* → **Esegui comunque**.
3. Aspetta la fine (si apre VS Code da solo), poi premi un tasto per chiudere la finestra nera.

**Mac**
1. Apri il Terminale nella cartella `Corso-C` (tasto destro sulla cartella → *Nuovo terminale nella cartella*).
2. Scrivi:
   ```
   bash setup/setup-mac.sh
   ```
3. Se si apre una finestra che chiede di installare gli strumenti di sviluppo, clicca **Installa**,
   aspetta la fine e rilancia lo stesso comando.

**Linux** (Ubuntu/Debian/Mint, Fedora, Arch, openSUSE)
1. Apri il Terminale nella cartella `Corso-C`.
2. Scrivi:
   ```
   bash setup/setup-linux.sh
   ```
3. Inserisci la tua password quando richiesta (serve per installare i pacchetti).

### 3. Apri la cartella in VS Code
Durante l'installazione lo script apre da solo VS Code sulla cartella `Corso-C`, usando il **profilo "Corso Info"**:
un profilo separato che contiene solo le estensioni del corso, così il tuo VS Code normale resta com'è.
Il nome del profilo attivo si vede in basso a sinistra (icona dell'ingranaggio).

Le volte successive basta aprire la cartella (*File → Apri cartella…* → `Corso-C`):
VS Code si ricorda di usare il profilo "Corso Info".

Se lo script non è riuscito a creare il profilo (comando `code` non trovato), apri la cartella a mano
e, quando VS Code propone di installare le estensioni consigliate (**clangd** e **CodeLLDB**), clicca **Installa**.

## Come si usa

| Cosa vuoi fare | Windows / Linux | Mac |
|---|---|---|
| Compilare ed eseguire (con debug) | `F5` | `F5` (o `Fn+F5`) |
| Solo compilare | `Ctrl+Shift+B` | `Cmd+Shift+B` |
| Mettere un breakpoint | clic a sinistra del numero di riga | uguale |
| Passo successivo durante il debug | `F10` | `F10` |
| Entrare in una funzione | `F11` | `F11` |
| Formattare il codice | si fa da solo quando salvi | uguale |

Il programma gira nel **terminale** in basso: lì vedi l'output e scrivi l'input (`scanf`).

Gli errori di compilazione appaiono sottolineati in rosso già mentre scrivi,
e nel pannello **Problemi** (`Ctrl+Shift+M` / `Cmd+Shift+M`).

## Organizzazione dei file

```
esempi/                  programmi di esempio, da guardare e provare
├── 01-ciao/ciao.c       primo programma
├── 02-input/somma.c     leggere numeri con scanf
└── 03-debug/media.c     esercizio guidato sul debugger
esercizi/                qui metti i tuoi programmi, una cartella per lezione
```

Per ogni lezione crea una cartella dentro `esercizi/` (per esempio `01-primi-passi`)
e mettici i tuoi file `.c`. In una cartella possono stare più programmi:
apri quello che vuoi provare e premi `F5`.

## Problemi comuni

- **`clang` non è riconosciuto** (Windows): chiudi e riapri VS Code dopo l'installazione.
  Se non basta, riavvia il computer.
- **`stdio.h` sottolineato in rosso**: VS Code non trova clangd. Su Windows riapri VS Code
  dopo l'installazione; su Mac e Linux accetta la proposta di scaricare clangd.
- **Il programma non si ferma sul breakpoint**: controlla di aver premuto `F5`
  e non il pulsante "Run" di altre estensioni.

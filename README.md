# Cross-Platform Dotfiles (Windows & WSL)

A clean, modern, and highly modular repository for managing terminal configuration files across Windows and Windows Subsystem for Linux (WSL).

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform Support](https://img.shields.io/badge/Platform-Windows%20%7C%20WSL%20Ubuntu-orange.svg)]()
[![Shell](https://img.shields.io/badge/Shell-Bash%20%7C%20PowerShell-brightgreen.svg)]()

---

## Repository Structure

```text
dotfiles/
├── alacritty/
│   ├── alacritty.toml         # Portable Alacritty config (Windows/WSL)
│   └── themes/
│       └── breeze.toml        # KDE Breeze color theme
├── tmux/
│   └── tmux.conf             # TMUX config with TPM support (WSL)
├── scripts/
│   ├── bootstrap.ps1         # Windows setup script (PowerShell)
│   └── bootstrap.sh          # WSL/Linux setup script (Bash)
├── .gitignore                # Rules for files to not track in Git
└── LICENSE                   # MIT License
```

---

## Features & Configurations

### Alacritty Terminal
*   **Performance**: Fast, GPU-accelerated terminal emulator configured for Windows.
*   **Shell Integration**: Automatically launches directly into WSL Ubuntu.
*   **Look & Feel**: Clean borders, custom window sizes, blinking block cursor, and KDE Breeze dark theme.
*   **Typography**: Styled with `Cascadia Mono` font (size 11).
*   **Quality of Life**:
    *   Windows-style copy-paste shortcuts (`Ctrl + Shift + C` / `Ctrl + Shift + V`).
    *   Quick mouse-free copy-paste using Alt-key variations (`Alt + C` / `Alt + V`).
    *   Easy scrollback clearing with `Ctrl + Shift + K`.

### Tmux Window Manager
*   **Navigation**: Vim-like pane navigation (`Prefix` + `h`/`j`/`k`/`l`).
*   **TPM Support**: Built-in compatibility with Tmux Plugin Manager.
*   **Visual Highlights**: Minimalist top status bar, centered window list, and transparent background.
*   **Sensible Defaults**: Mouse support enabled, 10,000-line history scrollback, and 0ms escape-time delay (great for Vim/Neovim).

---

## Installation & Setup

Before installing, make sure to clone this repository to your computer:
```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/OneDrive/Documents/Code/dotfiles
```

### Windows Setup (Alacritty)

#### Prerequisites
1.  **Fonts**: Install [Cascadia Code / Cascadia Mono](https://github.com/microsoft/cascadia-code/releases) (or any other Nerd Font of your choice).
2.  **Terminal**: Ensure [Alacritty](https://github.com/alacritty/alacritty) is installed on Windows.

#### Running the Bootstrap Script
Open PowerShell and run the Windows setup script:
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\scripts\bootstrap.ps1
```
*Note: If Developer Mode is disabled on Windows, the script will automatically fallback to a hard link or a direct copy so that administrative privileges are not strictly required.*

---

### WSL Setup (Tmux)

#### Prerequisites
Ensure `tmux` and `git` are installed inside WSL Ubuntu:
```bash
sudo apt update && sudo apt install tmux git -y
```

#### Running the Bootstrap Script
Run the bash setup script inside your WSL terminal:
```bash
chmod +x ./scripts/bootstrap.sh
./scripts/bootstrap.sh
```
*This will create the tmux symlink and automatically clone the Tmux Plugin Manager (TPM) if it's missing.*

#### Install Tmux Plugins
1.  Open `tmux`.
2.  Press `Ctrl + b` then `Shift + i` (i.e. `Ctrl + b` followed by `I` for Install).
3.  TPM will download and source your plugins automatically!

---

## Keyboard Shortcuts Cheat Sheet

### tmux Navigation

| Action | Shortcut |
| :--- | :--- |
| **Move Left** | `Ctrl + b` ➔ `h` |
| **Move Down** | `Ctrl + b` ➔ `j` |
| **Move Up** | `Ctrl + b` ➔ `k` |
| **Move Right** | `Ctrl + b` ➔ `l` |
| **Reload Config** | `Ctrl + b` ➔ `r` |
| **Toggle Status Bar** | `Ctrl + b` ➔ `b` |
| **Kill Session** | `Ctrl + b` ➔ `X` |

### Alacritty Actions

| Action | Shortcut |
| :--- | :--- |
| **Copy Text** | `Ctrl + Shift + C` or `Alt + C` |
| **Paste Text** | `Ctrl + Shift + V` or `Alt + V` |
| **Clear History** | `Ctrl + Shift + K` |
| **Cancel Selection** | `Shift + Escape` |

---

## License

This repository is licensed under the [MIT License](LICENSE). Feel free to fork, modify, and customize it!

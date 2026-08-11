# Cross-Platform Dotfiles (macOS & Windows/MSYS2)

A single source of truth for the terminal setup shared between the current Windows/MSYS2 machine and a new Mac.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform Support](https://img.shields.io/badge/Platform-macOS%20%7C%20Windows-orange.svg)]()
[![Shell](https://img.shields.io/badge/Shell-Zsh%20%7C%20Bash%20%7C%20PowerShell-brightgreen.svg)]()

---

## Repository Structure

```text
dotfiles/
├── alacritty/
│   ├── alacritty.toml         # Windows + MSYS2 Alacritty config
│   ├── alacritty.macos.toml   # macOS Alacritty config
│   └── themes/
│       └── breeze.toml        # KDE Breeze color theme
├── tmux/
│   └── tmux.conf              # Portable config with TPM support
├── zsh/
│   └── zshrc                  # macOS shell config
├── git/
│   └── gitconfig              # Portable public Git identity
├── optional/                  # Reviewed, non-secret app preferences
├── scripts/
│   ├── bootstrap-macos.sh     # Complete new-Mac setup
│   ├── bootstrap.ps1          # Windows Alacritty setup
│   └── bootstrap.sh           # MSYS2/WSL/Linux tmux setup
├── Brewfile                   # Mac packages and font
├── .gitignore                # Rules for files to not track in Git
└── LICENSE                   # MIT License
```

---

## Features & Configurations

### Alacritty Terminal
*   **Platform launchers**: MSYS2 UCRT64 on Windows and login zsh on macOS.
*   **Look & Feel**: 100x30 window, blinking Beam cursor, and KDE Breeze dark theme.
*   **Typography**: Styled with `Cascadia Mono` font (size 11).
*   **Quality of Life**:
    *   Native Mac copy/paste (`Command + C` / `Command + V`).
    *   Cross-platform copy/paste (`Ctrl + Shift + C` / `Ctrl + Shift + V`).
    *   Selection-to-clipboard and Shift+Enter support.

### Tmux Window Manager
*   **Navigation**: Vim-like pane navigation (`Prefix` + `h`/`j`/`k`/`l`).
*   **TPM Support**: Built-in compatibility with Tmux Plugin Manager.
*   **Visual Highlights**: Minimalist top status bar, centered window list, and transparent background.
*   **Clipboard**: Uses `pbcopy` on macOS and `clip.exe` under MSYS2.
*   **Plugins**: TPM, tmux-sensible, and tmux-menus.
*   **Sensible Defaults**: Mouse support, 50,000-line history, true color, and 0ms escape-time delay.

---

## Installation & Setup

### New Mac

1. Install [Homebrew](https://brew.sh/).
2. Install Alacritty using the current macOS DMG from the [official releases page](https://github.com/alacritty/alacritty/releases/latest).
3. Clone this repository and run the Mac bootstrap:

```bash
mkdir -p ~/Documents/Code
git clone https://github.com/anikdc/dotfiles.git ~/Documents/Code/dotfiles
cd ~/Documents/Code/dotfiles
chmod +x scripts/bootstrap-macos.sh
./scripts/bootstrap-macos.sh
```

The script installs Git, tmux, and Cascadia Mono through the `Brewfile`; backs up conflicting files under `~/.dotfiles-backup/<timestamp>`; links Alacritty, tmux, zsh, and Git configuration; and installs TPM plugins.

The Alacritty Homebrew cask is deliberately omitted because Homebrew schedules it for disabling on 2026-09-01. The upstream DMG remains the stable Mac installation route.

### Existing Windows/MSYS2 machine

Alacritty is installed from PowerShell:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\scripts\bootstrap.ps1
```

Tmux is installed from MSYS2/WSL/Linux Bash:

```bash
chmod +x scripts/bootstrap.sh
./scripts/bootstrap.sh
```

### Optional application settings

The `optional/` directory is not installed automatically:

* `optional/claude/settings.json` contains only theme and effort preferences.
* `optional/cursor/settings.review-before-install.json` preserves the live settings but enables permission bypass. Review it before installation.
* `optional/codex/config-portable.toml` contains only portable preferences. Merge it into the Mac-generated Codex config instead of replacing that file.
* `optional/codex/plugin-inventory.md` records plugins to reinstall through Codex.

Credentials, SSH private keys, histories, sessions, trusted-project grants, caches, and machine-generated runtime paths are intentionally excluded. Generate a new SSH key on the Mac:

```bash
ssh-keygen -t ed25519 -C "anik29dc@gmail.com"
```

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
| **Open Menu** | `Ctrl + b` ➔ `M` |

### Alacritty Actions

| Action | Shortcut |
| :--- | :--- |
| **Copy Text on Mac** | `Command + C` |
| **Paste Text on Mac** | `Command + V` |
| **Cross-platform Copy/Paste** | `Ctrl + Shift + C` / `Ctrl + Shift + V` |
| **Clear History on Mac** | `Command + K` |
| **Cancel Selection** | `Shift + Escape` |

---

## License

This repository is licensed under the [MIT License](LICENSE). Feel free to fork, modify, and customize it!

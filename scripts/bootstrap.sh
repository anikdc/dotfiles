#!/usr/bin/env bash

# bootstrap.sh
# Automates the portable tmux configuration inside MSYS2 / WSL / Linux.

set -euo pipefail

# Color helper variables
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}==> Starting tmux bootstrap script...${NC}"

# Resolve the repository root directory relative to this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_DIR="$( dirname "$SCRIPT_DIR" )"

# 1. Ensure config directory exists
TMUX_CONFIG_DIR="$HOME/.config/tmux"
mkdir -p "$TMUX_CONFIG_DIR"

# 2. Back up existing tmux config if it exists and is not a symlink
TMUX_DEST="$TMUX_CONFIG_DIR/tmux.conf"
TMUX_SOURCE="$REPO_DIR/tmux/tmux.conf"

if [ -e "$TMUX_DEST" ]; then
    if [ -L "$TMUX_DEST" ]; then
        echo -e "${BLUE}--> Existing symlink found at $TMUX_DEST. Removing it...${NC}"
        rm "$TMUX_DEST"
    else
        BACKUP="$TMUX_DEST.bak.$(date +%Y%m%d%H%M%S)"
        echo -e "${RED}--> Found existing physical config at $TMUX_DEST. Backing up to $BACKUP...${NC}"
        mv "$TMUX_DEST" "$BACKUP"
    fi
fi

# 3. Create the symlink
echo -e "${BLUE}--> Creating symbolic link: $TMUX_SOURCE -> $TMUX_DEST${NC}"
ln -s "$TMUX_SOURCE" "$TMUX_DEST"
echo -e "${GREEN}✓ tmux.conf successfully linked!${NC}"

# 4. Auto-install Tmux Plugin Manager (TPM) if missing
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
    echo -e "${BLUE}--> Installing Tmux Plugin Manager (TPM)...${NC}"
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    echo -e "${GREEN}✓ TPM installed! (Press Prefix + I in tmux to install plugins)${NC}"
else
    echo -e "${GREEN}✓ Tmux Plugin Manager (TPM) is already installed.${NC}"
fi

# 5. Reload tmux config if tmux is running
if [ -n "${TMUX:-}" ] || pgrep tmux >/dev/null 2>&1; then
    echo -e "${BLUE}--> TMUX session detected. Reloading configuration...${NC}"
    tmux source-file "$TMUX_DEST" || true
    echo -e "${GREEN}✓ Configuration reloaded!${NC}"
fi

echo -e "${GREEN}==> Setup completed successfully!${NC}"

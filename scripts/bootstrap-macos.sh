#!/usr/bin/env bash

set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  printf 'This bootstrap is for macOS only.\n' >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
BACKUP_ROOT="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

backup_target() {
  local target="$1"
  local relative="${target#"$HOME"/}"

  if [[ -e "$target" || -L "$target" ]]; then
    mkdir -p "$BACKUP_ROOT/$(dirname "$relative")"
    mv "$target" "$BACKUP_ROOT/$relative"
    printf 'Backed up %s -> %s\n' "$target" "$BACKUP_ROOT/$relative"
  fi
}

link_item() {
  local source="$1"
  local target="$2"

  backup_target "$target"
  mkdir -p "$(dirname "$target")"
  ln -s "$source" "$target"
  printf 'Linked %s -> %s\n' "$target" "$source"
}

if ! command -v brew >/dev/null 2>&1; then
  cat >&2 <<'EOF'
Homebrew is required for tmux, Git, and Cascadia Mono.
Install it from https://brew.sh/, then run this script again.
EOF
  exit 1
fi

brew bundle --file "$REPO_DIR/Brewfile"

link_item "$REPO_DIR/alacritty/alacritty.macos.toml" "$HOME/.config/alacritty/alacritty.toml"
link_item "$REPO_DIR/alacritty/themes" "$HOME/.config/alacritty/themes"
link_item "$REPO_DIR/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"
link_item "$REPO_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
link_item "$REPO_DIR/zsh/zshrc" "$HOME/.zshrc"
link_item "$REPO_DIR/git/gitconfig" "$HOME/.gitconfig"

TPM_DIR="$HOME/.tmux/plugins/tpm"
if [[ ! -d "$TPM_DIR/.git" ]]; then
  mkdir -p "$(dirname "$TPM_DIR")"
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

BOOTSTRAP_SESSION="__dotfiles_bootstrap_$$"
CREATED_SESSION=0
if ! tmux list-sessions >/dev/null 2>&1; then
  tmux new-session -d -s "$BOOTSTRAP_SESSION"
  CREATED_SESSION=1
fi

tmux source-file "$HOME/.config/tmux/tmux.conf"
"$TPM_DIR/bin/install_plugins" || {
  printf 'TPM plugin installation needs a retry: press Ctrl-b, then I, inside tmux.\n' >&2
}

if [[ "$CREATED_SESSION" -eq 1 ]]; then
  tmux kill-session -t "$BOOTSTRAP_SESSION" 2>/dev/null || true
fi

cat <<EOF

macOS dotfiles are installed.
Backups, if any, are under: $BACKUP_ROOT

Install Alacritty from its official DMG if needed:
https://github.com/alacritty/alacritty/releases/latest
EOF

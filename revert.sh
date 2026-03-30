#!/bin/bash
# Revert symlinked dotfiles back to pre-install state
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

restore_file() {
  local src="$1"
  local dst="$2"
  local bak="${dst}.bak"

  if [ -e "$bak" ] || [ -L "$bak" ]; then
    if [ -e "$dst" ] || [ -L "$dst" ]; then
      rm -f "$dst"
    fi
    mkdir -p "$(dirname "$dst")"
    mv "$bak" "$dst"
    echo "  ↩ restore $dst ← $bak"
    return
  fi

  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    rm -f "$dst"
    echo "  ✗ remove $dst (no backup)"
  else
    echo "  ⊘ skip $dst (nothing to revert)"
  fi
}

restore_dir() {
  local src="$1"
  local dst="$2"
  local bak="${dst}.bak"

  if [ -e "$bak" ] || [ -L "$bak" ]; then
    if [ -L "$dst" ]; then
      rm -f "$dst"
    elif [ -d "$dst" ]; then
      rm -rf "$dst"
    fi
    mkdir -p "$(dirname "$dst")"
    mv "$bak" "$dst"
    echo "  ↩ restore $dst ← $bak"
    return
  fi

  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    rm -f "$dst"
    echo "  ✗ remove $dst (no backup)"
  else
    echo "  ⊘ skip $dst (nothing to revert)"
  fi
}

echo "Reverting dotfiles installed from $DOTFILES_DIR..."
echo ""

# Ghostty
restore_file "$DOTFILES_DIR/ghostty/config" "$HOME/.config/ghostty/config"

# cmux
if [ -d "$DOTFILES_DIR/cmux" ]; then
  for f in "$DOTFILES_DIR/cmux"/*; do
    [ -f "$f" ] && restore_file "$f" "$HOME/.config/cmux/$(basename "$f")"
  done
fi

# OpenCode
restore_file "$DOTFILES_DIR/opencode/opencode.json" "$HOME/.config/opencode/opencode.json"
if [ -d "$DOTFILES_DIR/opencode/agents" ]; then
  for f in "$DOTFILES_DIR/opencode/agents"/*; do
    [ -f "$f" ] && restore_file "$f" "$HOME/.config/opencode/agents/$(basename "$f")"
  done
fi

# Neovim
restore_dir "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

# Git
restore_file "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"

# Zsh
restore_file "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"

# Starship
restore_file "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship.toml"

echo ""
echo "Done."

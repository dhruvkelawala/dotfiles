#!/bin/bash
# Symlink dotfiles from this repo to their expected locations
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

link() {
  local src="$1"
  local dst="$2"

  if [ ! -e "$src" ]; then
    echo "  ⊘ skip $dst (source not in repo)"
    return
  fi

  # Backup existing file if it's not already a symlink to us
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo "  ↗ backup $dst → ${dst}.bak"
    mv "$dst" "${dst}.bak"
  elif [ -L "$dst" ]; then
    rm "$dst"
  fi

  mkdir -p "$(dirname "$dst")"
  ln -sf "$src" "$dst"
  echo "  ✓ $dst → $src"
}

echo "Installing dotfiles from $DOTFILES_DIR..."
echo ""

# Ghostty
link "$DOTFILES_DIR/ghostty/config" "$HOME/.config/ghostty/config"

# cmux
if [ -d "$DOTFILES_DIR/cmux" ]; then
  for f in "$DOTFILES_DIR/cmux"/*; do
    [ -f "$f" ] && link "$f" "$HOME/.config/cmux/$(basename "$f")"
  done
fi

# OpenCode
link "$DOTFILES_DIR/opencode/opencode.json" "$HOME/.config/opencode/opencode.json"
if [ -d "$DOTFILES_DIR/opencode/agents" ]; then
  for f in "$DOTFILES_DIR/opencode/agents"/*; do
    [ -f "$f" ] && link "$f" "$HOME/.config/opencode/agents/$(basename "$f")"
  done
fi

# Neovim (link entire directory)
if [ -d "$DOTFILES_DIR/nvim" ]; then
  if [ -d "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ]; then
    echo "  ↗ backup ~/.config/nvim → ~/.config/nvim.bak"
    mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak"
  elif [ -L "$HOME/.config/nvim" ]; then
    rm "$HOME/.config/nvim"
  fi
  ln -sf "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
  echo "  ✓ ~/.config/nvim → $DOTFILES_DIR/nvim"
fi

# Git
link "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"

# Zsh
link "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"

# Starship
link "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship.toml"

echo ""
echo "Done. Restart your shell or run: source ~/.zshrc"

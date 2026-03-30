#!/bin/bash
# Collect current dotfiles into this repo (run once from the source machine)
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Collecting dotfiles into $DOTFILES_DIR..."

# Ghostty
mkdir -p "$DOTFILES_DIR/ghostty"
[ -f ~/.config/ghostty/config ] && cp ~/.config/ghostty/config "$DOTFILES_DIR/ghostty/config" && echo "  ✓ ghostty/config"

# cmux
if [ -d ~/.config/cmux ]; then
  mkdir -p "$DOTFILES_DIR/cmux"
  cp -R ~/.config/cmux/* "$DOTFILES_DIR/cmux/" 2>/dev/null && echo "  ✓ cmux/"
fi

# OpenCode
mkdir -p "$DOTFILES_DIR/opencode/agents"
[ -f ~/.config/opencode/opencode.json ] && cp ~/.config/opencode/opencode.json "$DOTFILES_DIR/opencode/opencode.json" && echo "  ✓ opencode/opencode.json"
if [ -d ~/.config/opencode/agents ]; then
  cp -R ~/.config/opencode/agents/* "$DOTFILES_DIR/opencode/agents/" 2>/dev/null && echo "  ✓ opencode/agents/"
fi

# Neovim
if [ -d ~/.config/nvim ]; then
  mkdir -p "$DOTFILES_DIR/nvim"
  rsync -a --exclude='node_modules' --exclude='.git' --exclude='lazy-lock.json' ~/.config/nvim/ "$DOTFILES_DIR/nvim/" && echo "  ✓ nvim/"
fi

# Git
mkdir -p "$DOTFILES_DIR/git"
[ -f ~/.gitconfig ] && cp ~/.gitconfig "$DOTFILES_DIR/git/.gitconfig" && echo "  ✓ git/.gitconfig"

# Zsh
mkdir -p "$DOTFILES_DIR/zsh"
[ -f ~/.zshrc ] && cp ~/.zshrc "$DOTFILES_DIR/zsh/.zshrc" && echo "  ✓ zsh/.zshrc"

# Starship
[ -f ~/.config/starship.toml ] && cp ~/.config/starship.toml "$DOTFILES_DIR/starship.toml" && echo "  ✓ starship.toml"

echo ""
echo "Done. Review the files, then:"
echo "  git add -A && git commit -m 'initial dotfiles' && git push"

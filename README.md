# dotfiles

Dhruv's dotfiles — synced across MacBook Pro and Mac Mini.

## Structure

```
dotfiles/
├── ghostty/config          → ~/.config/ghostty/config
├── cmux/                   → ~/.config/cmux/
├── opencode/opencode.json  → ~/.config/opencode/opencode.json
├── opencode/agents/        → ~/.config/opencode/agents/
├── nvim/                   → ~/.config/nvim/
├── git/.gitconfig          → ~/.gitconfig
├── zsh/.zshrc              → ~/.zshrc
├── install.sh              → symlink everything
└── README.md
```

## Setup

### First time (push from MacBook)
```bash
# Clone your existing configs into this repo
./collect.sh

# Push
git add -A && git commit -m "initial dotfiles"
git push
```

### On Mac Mini (or any new machine)
```bash
git clone git@github.com:dhruvkelawala/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

## How it works

`install.sh` creates symlinks from `~/.config/*` to the repo files. Your actual configs point to the repo, so any changes you make are automatically tracked by git.

`collect.sh` copies your current configs INTO the repo (one-time, for initial setup).

## Sync

```bash
# On the machine you changed things on:
cd ~/.dotfiles && git add -A && git commit -m "update" && git push

# On the other machine:
cd ~/.dotfiles && git pull
```

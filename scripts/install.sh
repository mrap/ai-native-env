#!/usr/bin/env bash
# Interactive installer for ai-native-env
# Designed to be run by Claude Code following WIZARD.md
# Can also be run standalone for quick setup
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "=== ai-native-env Installer ==="
echo "Source: $REPO_DIR"
echo ""

# --- Gather info ---
read -p "Full name (for git): " USER_NAME
read -p "Email (for git): " USER_EMAIL
read -p "GitHub username: " GITHUB_USER

# --- Create directory structure ---
mkdir -p "$HOME/github.com/$GITHUB_USER"
echo "Created ~/github.com/$GITHUB_USER/"

# --- Deploy configs ---
deploy() {
  local src="$1" dst="$2" name="$3"
  mkdir -p "$(dirname "$dst")"
  if [ -f "$dst" ]; then
    cp "$dst" "${dst}.backup.$(date +%s)"
    echo "  Backed up existing $name"
  fi
  cp "$src" "$dst"
  echo "  Installed $name"
}

echo ""
echo "Deploying configs..."
deploy "$REPO_DIR/zsh/zshrc" "$HOME/.zshrc" "zshrc"
deploy "$REPO_DIR/starship/starship.toml" "$HOME/.config/starship.toml" "starship"
deploy "$REPO_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua" "neovim"
deploy "$REPO_DIR/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf" "tmux"

# Git config with substitution
sed "s/__USER_NAME__/$USER_NAME/g; s/__USER_EMAIL__/$USER_EMAIL/g" \
  "$REPO_DIR/git/gitconfig.template" > "$HOME/.gitconfig.new"
if [ -f "$HOME/.gitconfig" ]; then
  cp "$HOME/.gitconfig" "$HOME/.gitconfig.backup.$(date +%s)"
  echo "  Backed up existing gitconfig"
fi
mv "$HOME/.gitconfig.new" "$HOME/.gitconfig"
echo "  Installed gitconfig"

# Claude settings
mkdir -p "$HOME/.claude"
deploy "$REPO_DIR/claude/settings.json" "$HOME/.claude/settings.json" "claude settings"

# Secrets file
if [ ! -f "$HOME/.secrets" ]; then
  touch "$HOME/.secrets"
  chmod 600 "$HOME/.secrets"
  echo "  Created ~/.secrets (add API keys here)"
fi

echo ""
echo "Done! Restart your shell or run: source ~/.zshrc"

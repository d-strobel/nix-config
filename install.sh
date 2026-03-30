#!/usr/bin/env bash

# Dotfiles install script for debian based devcontainers.

set -e

DOTFILES_SOURCE_PATH="$HOME/dotfiles/home-manager/dotfiles"
DOTFILES_TARGET_PATH="$HOME/.config"

echo "Start devcontainer setup"

# Check if fish is installed
if ! command -v fish >/dev/null 2>&1; then
  echo "fish is not installed - abort setup"
  exit 1
fi

echo "Install mise"
curl https://mise.run | sh

echo "Copy devcontainer dotfiles"
cp -R "$DOTFILES_SOURCE_PATH/fish-devcontainer" "$DOTFILES_TARGET_PATH/fish"
cp -R "$DOTFILES_SOURCE_PATH/nvim" "$DOTFILES_TARGET_PATH/nvim"
cp -R "$DOTFILES_SOURCE_PATH/mise" "$DOTFILES_TARGET_PATH/mise"

echo "Set user shell to fish"
sudo chsh vscode --shell "$(which fish)"

echo "Install applications via mise"
"$HOME/.local/bin/mise" install

echo "Finished devcontainer setup"

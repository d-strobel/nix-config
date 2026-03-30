#!/usr/bin/env bash

# Dotfiles install script for debian based devcontainers.

set -e

DOTFILES_SOURCE_PATH="$HOME/dotfiles/home-manager/dotfiles"
DOTFILES_TARGET_PATH="$HOME/.config"

echo "Start devcontainer setup"

echo "Install devcontainer dependencies"
sudo apt-get install -y \
  fish \
  fzf \
  direnv \
  zoxide \
  ripgrep \
  fd-find

echo "Copy devcontainer dotfiles"
cp -R "$DOTFILES_SOURCE_PATH/fish-devcontainer" "$DOTFILES_TARGET_PATH/fish"
cp -R "$DOTFILES_SOURCE_PATH/nvim" "$DOTFILES_TARGET_PATH/nvim"

echo "Set user shell to fish"
sudo chsh vscode --shell "$(which fish)"

echo "Finished devcontainer setup"

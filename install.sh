#!/usr/bin/env bash

set -e

echo "Start devcontainer setup"

# Copy dotfiles
echo "Copy devcontainer dotfiles"
cp -R "$HOME/dotfiles/home-manager/dotfiles/fish-devcontainer" "$HOME/.config/fish"
cp -R "$HOME/dotfiles/home-manager/dotfiles/nvim" "$HOME/.config/nvim"

# Set user shell
echo "Set user shell to fish"
sudo chsh vscode --shell "$(which fish)"

echo "Finished devcontainer setup"

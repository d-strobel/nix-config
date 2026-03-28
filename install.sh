#!/usr/bin/env bash
set -e

echo "Setup devcontainer dotfiles"

# Copy dotfiles
cp -R "$HOME/dotfiles/home-manager/dotfiles/fish-devcontainer" "$HOME/.config/fish"
cp -R "$HOME/dotfiles/home-manager/dotfiles/nvim" "$HOME/.config/nvim"

echo "Finish devcontainer dotfiles setup"

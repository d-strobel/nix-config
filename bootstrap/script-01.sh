#!/usr/bin/bash

# Variables
GIT_BASE_DIR="$HOME/git/github.com/d-strobel"
SOPS_AGE_DIR="$HOME/.config/sops/age"
SOPS_AGE_KEYS_FILE="$SOPS_AGE_DIR/keys.txt"

# Create directories
mkdir -p "$GIT_BASE_DIR"
mkdir -p "$SOPS_AGE_DIR"
touch "$SOPS_AGE_KEYS_FILE"
chmod 600 "$SOPS_AGE_KEYS_FILE"

# Set the global Dark Theme
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark

# Install fish shell here and via nix to workaround
# an issue where I can't use fish as the main shell
# in the foot terminal.
# Install libvirt system-wide.
rpm-ostree install --idempotent fish libvirt

# Set transient rootfs
# This lets us create the /nix directory
sudo tee /etc/ostree/prepare-root.conf <<'EOL'
[composefs]
enabled = yes
[root]
transient = true
EOL

# Reboot required for transient rootfs
rpm-ostree initramfs-etc --reboot --track=/etc/ostree/prepare-root.conf

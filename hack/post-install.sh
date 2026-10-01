#!/usr/bin/env bash

set -euo pipefail

NIXOS_ROOT_MOUNT="/mnt/root"
NIXOS_USERNAME="dstrobel"
NIXOS_UID="1000"
NIXOS_CONFIG_REPO="https://github.com/d-strobel/nix-config.git"

# Check if we are root
if [[ $EUID -ne 0 ]]; then
    echo "Error: This script must be run as root." >&2
    exit 1
fi

# Check if filesystem is mounted
if ! mountpoint -q "$NIXOS_ROOT_MOUNT"; then
    echo "Error: $NIXOS_ROOT_MOUNT is not a mountpoint. Aborting." >&2
    exit 1
fi

echo "Info:  Start script"

# Remove hosts file and create a new one
# Temporary solution for vaultwarden access
if ! grep -q 'vaultwarden.dstrobel.com' /etc/hosts; then
    echo "Info:  Setup /etc/hosts"
    rm -f /etc/hosts
    tee /etc/hosts > /dev/null << 'EOF'
127.0.0.1 localhost
::1 localhost
192.168.11.10 vaultwarden.dstrobel.com
EOF
    echo "Info:  Done /etc/hosts"
fi

# Create root directories and age keys file
if [[ ! -f "$NIXOS_ROOT_MOUNT/var/lib/sops/keys.txt" ]]; then
    echo "Info:  Setup $NIXOS_ROOT_MOUNT/var/lib/sops/keys.txt"
    mkdir -m 700 "$NIXOS_ROOT_MOUNT/var/lib/sops"
    mkdir -m 700 "$NIXOS_ROOT_MOUNT/var/lib/sops/age"
    touch "$NIXOS_ROOT_MOUNT/var/lib/sops/keys.txt"
    chmod 600 "$NIXOS_ROOT_MOUNT/var/lib/sops/keys.txt"
    chown -R root:root "$NIXOS_ROOT_MOUNT/var/lib/sops"
    echo "Info:  Done $NIXOS_ROOT_MOUNT/var/lib/sops/keys.txt"
fi

# Create user directories and age keys file
if [[ ! -f "$NIXOS_ROOT_MOUNT/home/$NIXOS_USERNAME/.config/sops/age/keys.txt" ]]; then
    echo "Info:  Setup $NIXOS_ROOT_MOUNT/home/$NIXOS_USERNAME/.config/sops/age/keys.txt"
    mkdir -m 700 "$NIXOS_ROOT_MOUNT/home/$NIXOS_USERNAME/.config"
    mkdir -m 700 "$NIXOS_ROOT_MOUNT/home/$NIXOS_USERNAME/.config/sops"
    mkdir -m 700 "$NIXOS_ROOT_MOUNT/home/$NIXOS_USERNAME/.config/sops/age"
    touch "$NIXOS_ROOT_MOUNT/home/$NIXOS_USERNAME/.config/sops/age/keys.txt"
    chmod 600 "$NIXOS_ROOT_MOUNT/home/$NIXOS_USERNAME/.config/sops/age/keys.txt"
    chown -R "$NIXOS_UID:users" "$NIXOS_ROOT_MOUNT/home/$NIXOS_USERNAME/.config"
    echo "Info:  Done $NIXOS_ROOT_MOUNT/home/$NIXOS_USERNAME/.config/sops/age/keys.txt"
fi

# Create user netrc file
if [[ ! -f "$NIXOS_ROOT_MOUNT/home/$NIXOS_USERNAME/.netrc" ]]; then
    echo "Info:  Setup $NIXOS_ROOT_MOUNT/home/$NIXOS_USERNAME/.netrc"
    touch "$NIXOS_ROOT_MOUNT/home/$NIXOS_USERNAME/.netrc"
    chmod 600 "$NIXOS_ROOT_MOUNT/home/$NIXOS_USERNAME/.netrc"
    chown "$NIXOS_UID:users" "$NIXOS_ROOT_MOUNT/home/$NIXOS_USERNAME/.netrc"
    echo "Info:  Done $NIXOS_ROOT_MOUNT/home/$NIXOS_USERNAME/.netrc"
fi

# Clone nix-config git repository
if [[ ! -d "$NIXOS_ROOT_MOUNT/home/$NIXOS_USERNAME/git/github.com/d-strobel/nix-config/.git" ]]; then
    echo "Info:  Setup $NIXOS_ROOT_MOUNT/home/$NIXOS_USERNAME/git/github.com/d-strobel/nix-config"
    mkdir -m 755 "$NIXOS_ROOT_MOUNT/home/$NIXOS_USERNAME/git"
    mkdir -m 755 "$NIXOS_ROOT_MOUNT/home/$NIXOS_USERNAME/git/github.com"
    mkdir -m 755 "$NIXOS_ROOT_MOUNT/home/$NIXOS_USERNAME/git/github.com/d-strobel"
    git clone "$NIXOS_CONFIG_REPO" "$NIXOS_ROOT_MOUNT/home/$NIXOS_USERNAME/git/github.com/d-strobel/nix-config"
    chown -R "$NIXOS_UID:users" "$NIXOS_ROOT_MOUNT/home/$NIXOS_USERNAME/git"
    echo "Info:  Done $NIXOS_ROOT_MOUNT/home/$NIXOS_USERNAME/git/github.com/d-strobel/nix-config"
fi

echo "Info:  End script"

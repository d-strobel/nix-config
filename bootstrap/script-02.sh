#!/usr/bin/bash

# Install Nix
curl -fsSL https://install.determinate.systems/nix | sh -s -- install ostree

# Firewall
firewall-cmd --permanent --add-port=53317/tcp # Localsend
firewall-cmd --reload

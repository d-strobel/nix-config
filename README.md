<!-- Badges -->
[![Test][test badge]][test page]

![logo](./images/nixos.png)

# nix-config

Personal NixOS configuration

## Installation

> This is the most simple installation method for me right now.

1. Install NixOS via GUI Installer (e.g. Gnome)
1. Install without any WindowManager
1. Use the correct user + password (User should be admin as well)
1. Activate LUKS encryption
1. Boot into the system
1. Login with the user
1. Connect to Wifi: `nmcli device wifi connect <SSID> password <PASSWORD>`
1. Create temporary shell: `nix-shell -p vim git home-manager`
1. Clone this repo: `git clone https://github.com/d-strobel/nix-config.git`
1. Install system flake: `sudo nixos-rebuild switch --experimental-features 'nix-command flakes' --flake .#HOST`

## Inspirations

* [youtube.com/@vimjoyer](https://www.youtube.com/@vimjoyer)
* [nixalted.com/](https://nixalted.com/)
* [github.com/Andrey0189/nixos-config-reborn](https://github.com/Andrey0189/nixos-config-reborn/tree/master)

<!-- Badges -->
[test badge]: https://github.com/d-strobel/nix-config/actions/workflows/test.yml/badge.svg
[test page]: https://github.com/d-strobel/nix-config/actions/workflows/test.yml

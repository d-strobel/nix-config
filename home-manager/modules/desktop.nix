{
  config,
  cfg,
  pkgs,
  inputs,
  ...
}: let
  # Custom symlinking
  mkSymlinkAttrs = import ../../lib/mkSymlinkAttrs.nix {
    inherit pkgs;
    inherit (cfg) context runtimeRoot;
    hm = config.lib;
  };
in {
  # Enable the nixGL integration
  targets.genericLinux.nixGL = {
    packages = inputs.nixgl.packages.${pkgs.stdenv.hostPlatform.system};
  };

  # OpenGL desktop applications
  home.packages = [
    (config.lib.nixGL.wrap pkgs.signal-desktop)
    (config.lib.nixGL.wrap pkgs.obsidian)
    (config.lib.nixGL.wrap pkgs.localsend)
  ];

  home.file = mkSymlinkAttrs {
    # Wayland compositor
    "./.config/sway" = {
      source = ../dotfiles/sway;
      outOfStoreSymlink = true;
      recursive = true;
    };

    # Wayland status bar
    "./.config/waybar" = {
      source = ../dotfiles/waybar;
      outOfStoreSymlink = true;
      recursive = true;
    };

    # Application launcher
    "./.config/rofi" = {
      source = ../dotfiles/rofi;
      outOfStoreSymlink = true;
      recursive = true;
    };
  };
}

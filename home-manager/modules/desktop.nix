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
    (config.lib.nixGL.wrap pkgs.satty)
    (config.lib.nixGL.wrap inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default)
  ];

  # Rofi
  programs.rofi = {
    enable = true;
    theme = "android_notification";
    font = "JetBrainsMono Nerd Font 12";
    plugins = with pkgs; [
      rofi-calc
    ];
    extraConfig = {
      # Enable fuzzy finding
      matching = "fuzzy";

      # Deactivate default bindings
      kb-remove-to-eol = "";
      kb-mode-next = "";
      kb-mode-previous = "";
      kb-mode-complete = "";

      # Activate vim-like navigation
      kb-accept-entry = "Control+l,Return,KP_Enter";
      kb-row-up = "Up,Control+p,Control+k";
      kb-row-down = "Down,Control+n,Control+j";
    };
  };

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
  };
}

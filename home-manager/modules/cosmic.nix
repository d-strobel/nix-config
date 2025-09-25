{
  cfg,
  config,
  pkgs,
  ...
}: let
  # Custom symlinking
  mkSymlinkAttrs = import ../../lib/mkSymlinkAttrs.nix {
    inherit pkgs;
    inherit (cfg) context runtimeRoot;
    hm = config.lib;
  };
in {
  home.packages = with pkgs; [
    cosmic-edit
    cosmic-files
  ];

  home.file = mkSymlinkAttrs {
    ".config/cosmic" = {
      source = ../dotfiles/cosmic;
      outOfStoreSymlink = true;
      recursive = true;
    };
  };

  # Rose-Pine dark theme
  # home.file."./.config/cosmic/com.system76.CosmicTheme.Dark" = {
  #   enable = true;
  #   source = ../dotfiles/cosmic/com.system76.CosmicTheme.Dark;
  #   recursive = true;
  # };
  #
  # # Cosmic editor config
  # home.file."./.config/cosmic/com.system76.CosmicEdit" = {
  #   enable = true;
  #   source = ../dotfiles/cosmic/com.system76.CosmicEdit;
  #   recursive = true;
  # };
}

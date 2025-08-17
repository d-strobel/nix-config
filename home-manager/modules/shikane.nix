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
  services.shikane = {
    enable = true;
    package = with pkgs; shikane;
  };

  home.file = mkSymlinkAttrs {
    ".config/shikane/config.toml" = {
      source = ../dotfiles/shikane/config.toml;
      outOfStoreSymlink = true;
      recursive = false;
    };
  };
}

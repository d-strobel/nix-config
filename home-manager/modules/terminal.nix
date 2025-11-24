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
    # Terminal Emulator
    alacritty
  ];

  home.file = mkSymlinkAttrs {
    # Terminal Emulator
    ".config/alacritty/alacritty.toml" = {
      source = ../dotfiles/alacritty/alacritty.toml;
      outOfStoreSymlink = true;
      recursive = false;
    };

    # Command line prompt
    ".config/starship.toml" = {
      source = ../dotfiles/starship/starship.toml;
      outOfStoreSymlink = true;
      recursive = false;
    };
  };

  # Command line prompt
  programs.starship = {
    enable = true;
    package = with pkgs; starship;
    enableFishIntegration = true;
  };

  # A better cd
  programs.zoxide = {
    enable = true;
    package = with pkgs; zoxide;
    enableFishIntegration = true;
    options = [
      "--cmd cd"
    ];
  };

  # Terminal fuzzy finder
  programs.fzf = {
    enable = true;
    package = with pkgs; fzf;
    enableFishIntegration = true;
  };

  # Directory specific env files
  programs.direnv = {
    enable = true;
    package = with pkgs; direnv;

    nix-direnv = {
      enable = true;
      package = with pkgs; nix-direnv;
    };
  };

  # Deploy envrc secret files
  sops.secrets = let
    home = config.home.homeDirectory;
  in {
    "direnv/git/gitlab.com/strobel-iac/envrc" = {
      path = "${home}/git/gitlab.com/strobel-iac/.envrc";
      mode = "0600";
    };
    "direnv/git/github.com/envrc" = {
      path = "${home}/git/github.com/.envrc";
      mode = "0600";
    };
  };
}

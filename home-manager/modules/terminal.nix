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
    tmux
  ];

  home.file = mkSymlinkAttrs {
    # Terminal Emulator
    ".config/foot/foot.ini" = {
      source = ../dotfiles/foot/foot.ini;
      outOfStoreSymlink = true;
      recursive = false;
    };

    # Terminal Multiplexer
    ".config/tmux/tmux.conf" = {
      source = ../dotfiles/tmux/tmux.conf;
      outOfStoreSymlink = true;
      recursive = false;
    };
    ".local/bin/tmux-sessions.sh" = {
      source = ../dotfiles/tmux/tmux-sessions.sh;
      outOfStoreSymlink = true;
      recursive = false;
    };
    ".local/bin/tmux-sessionizer.sh" = {
      source = ../dotfiles/tmux/tmux-sessionizer.sh;
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

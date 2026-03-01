{
  config,
  cfg,
  pkgs,
  lib,
  inputs,
  ...
}: let
  # Custom symlinking
  mkSymlinkAttrs = import ../lib/mkSymlinkAttrs.nix {
    inherit pkgs;
    inherit (cfg) context runtimeRoot;
    hm = config.lib;
  };

  # Sops secrets path
  secretsPath = toString inputs.nix-secrets;
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ./modules/librewolf.nix
  ];

  # --------------------
  # Nix configuration
  # --------------------
  nix = {
    package = with pkgs; nix;
    settings.experimental-features = ["nix-command" "flakes"];
  };
  nixpkgs.config.allowUnfree = true;

  # --------------------
  # Home
  # --------------------
  home.username = "dstrobel";
  home.homeDirectory = "/home/dstrobel";

  # --------------------
  # Packages
  # --------------------
  home.packages = [
    # Neovim
    inputs.neovim-nightly.packages.${pkgs.stdenv.hostPlatform.system}.default

    # Helium Browser
    inputs.helium-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ] ++ (with pkgs; [
    # Terminal
    foot
    tmux
    zoxide
    fzf
    direnv
    nix-direnv
    keychain

    # Desktop applications
    obsidian
    signal-desktop
    pavucontrol
    thunar
    thunar-volman
    thunar-archive-plugin
    vlc
    gnome-disk-utility
    gnome-calculator
    winbox4
    localsend
    brave
    remmina
    ledger-live-desktop
    glib
    gsettings-desktop-schemas
    adwaita-icon-theme

    # CLI tools
    ffmpeg
    ripgrep
    fd
    playerctl
    brightnessctl
    openssl
    ipcalc
    imagemagick
    devpod
    devbox

    # Screenshot tools
    satty

    # Notifications
    dunst

    # Status Bar
    waybar

    # Fonts
    font-awesome
    jetbrains-mono
    nerd-fonts.jetbrains-mono

    # Clipboard
    wl-clipboard-rs
    wl-clip-persist

    # Window-Manager tools
    libnotify
    rofi

    # Neovim devtools
    tree-sitter
    gcc
    lua-language-server
    nixd
    alejandra
    ansible-lint
    terraform-ls
    tofu-ls
    bash-language-server
    rust-analyzer
    gopls
    just-lsp
    jsonschema
    nodePackages.vscode-json-languageserver
    yaml-language-server
    dockerfile-language-server
    basedpyright
    fish-lsp
    tinymist
  ]);

  # --------------------
  # Dotfiles
  # --------------------
  home.file = mkSymlinkAttrs {
    # Window manager
    ".config/sway" = {
      source = ./dotfiles/sway;
      outOfStoreSymlink = true;
      recursive = true;
    };

    # Screenlock
    ".config/swaylock" = {
      source = ./dotfiles/swaylock;
      outOfStoreSymlink = true;
      recursive = true;
    };

    # Display setup
    ".config/kanshi" = {
      source = ./dotfiles/kanshi;
      outOfStoreSymlink = true;
      recursive = true;
    };

    # Notifications
    ".config/dunst" = {
      source = ./dotfiles/dunst;
      outOfStoreSymlink = true;
      recursive = true;
    };

    # Status Bar
    ".config/waybar" = {
      source = ./dotfiles/waybar;
      outOfStoreSymlink = true;
      recursive = true;
    };

    # Status Bar
    ".local/share/themes/Adwaita-dark" = {
      source = ./dotfiles/Adwaita-dark;
      outOfStoreSymlink = true;
      recursive = true;
    };

    # Terminal Emulator
    ".config/foot" = {
      source = ./dotfiles/foot;
      outOfStoreSymlink = true;
      recursive = true;
    };

    # Fish
    ".config/fish/config.fish" = {
      source = ./dotfiles/fish/config.fish;
      outOfStoreSymlink = true;
      recursive = false;
    };
    ".config/fish/functions" = {
      source = ./dotfiles/fish/functions;
      outOfStoreSymlink = true;
      recursive = true;
    };

    # Tmux
    ".config/tmux" = {
      source = ./dotfiles/tmux;
      outOfStoreSymlink = true;
      recursive = true;
    };

    # Git
    ".config/git" = {
      source = ./dotfiles/git;
      outOfStoreSymlink = true;
      recursive = true;
    };

    # Scripts
    ".local/bin" = {
      source = ./dotfiles/dot_local_bin;
      outOfStoreSymlink = true;
      recursive = true;
    };

    # Btop
    ".config/btop" = {
      source = ./dotfiles/btop;
      outOfStoreSymlink = true;
      recursive = true;
    };

    # Rofi
    ".config/rofi" = {
      source = ./dotfiles/rofi;
      outOfStoreSymlink = true;
      recursive = true;
    };

    # Neovim
    ".config/nvim" = {
      source = ./dotfiles/nvim;
      outOfStoreSymlink = true;
      recursive = true;
    };

    # Wallpaper
    ".config/wallpaper" = {
      source = ./wallpaper;
      outOfStoreSymlink = true;
      recursive = true;
    };
  };

  # --------------------
  # SOPS Secrets
  # --------------------
  sops = let
    home = config.home.homeDirectory;
    remminaConfigDir = "${config.home.homeDirectory}/.local/share/remmina";
  in {
    age.keyFile = "${home}/.config/sops/age/keys.txt";
    defaultSopsFile = "${secretsPath}/secrets.yaml";
    validateSopsFiles = true;

    secrets = {
      # Netrc
      "netrc" = {
        path = "${home}/.netrc";
        mode = "0600";
      };

      # Git envrc files
      "git/gitlab.com/envrc" = {
        path = "${home}/git/gitlab.com/.envrc";
        mode = "0600";
      };
      "git/gitlab.com/strobel-iac/envrc" = {
        path = "${home}/git/gitlab.com/strobel-iac/.envrc";
        mode = "0600";
      };
      "git/github.com/envrc" = {
        path = "${home}/git/github.com/.envrc";
        mode = "0600";
      };

      # Git config files
      "git/github.com/config" = {
        path = "${home}/git/github.com/.gitconfig";
        mode = "0640";
      };
      "git/gitlab.com/config" = {
        path = "${home}/git/gitlab.com/.gitconfig";
        mode = "0640";
      };

      # SSH config
      "ssh/config" = {
        path = "${home}/.ssh/config";
        mode = "0600";
      };

      # SSH key-pairs
      "ssh/keys/id_ed25519/private" = {
        path = "${home}/.ssh/id_ed25519";
        mode = "0600";
      };
      "ssh/keys/id_ed25519/public" = {
        path = "${home}/.ssh/id_ed25519.pub";
        mode = "0644";
      };
      "ssh/keys/id_ed25519_vault-prod/private" = {
        path = "${home}/.ssh/id_ed25519_vault-prod";
        mode = "0600";
      };
      "ssh/keys/id_ed25519_vault-prod/public" = {
        path = "${home}/.ssh/id_ed25519_vault-prod.pub";
        mode = "0644";
      };

      # Remmina
      "remmina/connections/rds" = {
        path = "${remminaConfigDir}/sdk_rdp_rds.remmina";
        mode = "0640";
      };
      "remmina/connections/domaincontroller" = {
        path = "${remminaConfigDir}/sdk_rdp_domaincontroller.remmina";
        mode = "0640";
      };
      "remmina/connections/adfs" = {
        path = "${remminaConfigDir}/sdk_rdp_adfs.remmina";
        mode = "0640";
      };
    };
  };

  # --------------------
  # DConf
  # --------------------
  dconf.settings = {
    # Libvirt config
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };

    # Desktop dark appearance
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
    };
  };

  # --------------------
  # XDG
  # --------------------
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };

    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        # "image/jpeg" = "org.gnome.Loupe.desktop";
        # "image/png" = "org.gnome.Loupe.desktop";
        "text/plain" = "org.gnome.TextEditor.desktop";
        "text/html" = "org.gnome.TextEditor.desktop";
        "text/csv" = "org.gnome.TextEditor.desktop";
        "application/pdf" = ["librewolf.desktop"];
        # "application/zip" = "org.gnome.FileRoller.desktop";
        # "application/x-tar" = "org.gnome.FileRoller.desktop";
        # "application/x-bzip2" = "org.gnome.FileRoller.desktop";
        # "application/x-gzip" = "org.gnome.FileRoller.desktop";
        "x-scheme-handler/http" = ["librewolf.desktop" "chromium-browser.desktop"];
        "x-scheme-handler/https" = ["librewolf.desktop" "chromium-browser.desktop"];
        "x-scheme-handler/about" = ["librewolf.desktop" "chromium-browser.desktop"];
        "x-scheme-handler/unknown" = ["librewolf.desktop" "chromium-browser.desktop"];
        # "x-scheme-handler/mailto" = [""];
        "audio/mp3" = "vlc.desktop";
        "audio/x-matroska" = "vlc.desktop";
        "video/webm" = "vlc.desktop";
        "video/mp4" = "vlc.desktop";
        "video/x-matroska" = "vlc.desktop";
        # "inode/directory" = "pcmanfm.desktop";
      };
    };
  };

  # --------------------
  # Directories
  # --------------------
  home.activation.createDirs =
    lib.hm.dag.entryAfter ["writeBoundary"]
    /*
    bash
    */
    ''
      # Git
      mkdir -p ${config.home.homeDirectory}/git/github.com/d-strobel
      mkdir -p ${config.home.homeDirectory}/git/github.com/laser-zentrale-de
      mkdir -p ${config.home.homeDirectory}/git/gitlab.com/strobel-iac
    '';

  # --------------------
  # Systemd services
  # --------------------

  # Clipboard service
  systemd.user.services.wl-clip-persist = let
    wlClipPersist = "${pkgs.wl-clip-persist}/bin/wl-clip-persist";
  in {
    Unit = {
      Description = "Persistent clipboard for Wayland";
      Documentation = "https://github.com/Linus789/wl-clip-persist";
      Requires = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${wlClipPersist} --clipboard regular";
      Type = "simple";
      Restart = "always";
    };
  };

  # --------------------
  # Misc
  # --------------------

  # Let home-manager manage itself.
  programs.home-manager.enable = true;

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.
}

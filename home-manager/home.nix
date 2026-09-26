{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  # Symlink paths
  hmPath = "${config.home.homeDirectory}/git/github.com/d-strobel/nix-config/home-manager";
  dotfilesPath = "${config.home.homeDirectory}/git/github.com/d-strobel/dotfiles";

  # Sops secrets path
  secretsPath = toString inputs.nix-secrets;

  # devsy
  devsy = pkgs.stdenv.mkDerivation rec {
    pname = "devsy";
    version = "1.19.0";

    src = pkgs.fetchurl {
      url = "https://github.com/devsy-org/devsy/releases/download/v${version}/devsy-linux-amd64";
      sha256 = "sha256-L0PyirWzmbN5CRrrCWKOxrcNyCISpk0w3o4qShiknvU=";
    };

    dontUnpack = true;
    phases = ["installPhase" "postInstall"];
    installPhase = ''
      mkdir -p $out/bin
      cp ${src} $out/bin/devsy
      chmod +x $out/bin/devsy
    '';
    postInstall = ''
      mkdir -p $out/share/fish/vendor_completions.d
      $out/bin/devsy completion fish > $out/share/fish/vendor_completions.d/devsy.fish
    '';
  };

  # Devpod (fork)
  devpod = pkgs.stdenv.mkDerivation rec {
    pname = "devpod";
    version = "0.25.0";

    src = pkgs.fetchurl {
      url = "https://github.com/skevetter/devpod/releases/download/v${version}/devpod-linux-amd64";
      sha256 = "sha256-OlCPrxrc57yYCl0z+FFfTqJ8Ifxzplc2QsvlduA/ApI=";
    };

    dontUnpack = true;
    phases = ["installPhase" "postInstall"];
    installPhase = ''
      mkdir -p $out/bin
      cp ${src} $out/bin/devpod
      chmod +x $out/bin/devpod
    '';
    postInstall = ''
      mkdir -p $out/share/fish/vendor_completions.d
      $out/bin/devpod completion fish > $out/share/fish/vendor_completions.d/devpod.fish
    '';
  };
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    inputs.betterfox.modules.homeManager.betterfox
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
  home.packages =
    [
      # Neovim
      inputs.neovim-nightly.packages.${pkgs.stdenv.hostPlatform.system}.default

      # Devpod (fork)
      devpod

      devsy
    ]
    ++ (with pkgs; [
      # Terminal
      foot
      tmux
      herdr
      zoxide
      fzf
      direnv
      nix-direnv
      keychain

      # Desktop applications
      pcmanfm
      obsidian
      signal-desktop
      pavucontrol
      vlc
      gnome-disk-utility
      gnome-calculator
      winbox4
      localsend
      brave-origin
      remmina
      ledger-live-desktop
      glib
      gsettings-desktop-schemas
      adwaita-icon-theme
      sioyek
      librepods
      proton-vpn
      engrampa

      # CLI tools
      ffmpeg
      ripgrep
      fd
      playerctl
      brightnessctl
      openssl
      ipcalc
      imagemagick
      imv
      jq

      # Screenshot tools
      grim
      slurp
      satty

      # Notifications
      dunst

      # Time-based dark/light theme
      darkman

      # Window manager tools
      i3status-rust
      swaylock

      # Clipboard
      wl-clipboard-rs
      wl-clip-persist

      # Application launcher
      fuzzel

      # Neovim dependencies
      gcc
      tree-sitter

      # Neovim LSPs
      alejandra
      ansible-lint
      ansible-language-server
      basedpyright
      bash-language-server
      docker-language-server
      fish-lsp
      gopls
      lua-language-server
      jinja-lsp
      jsonschema
      md-lsp
      nixd
      rust-analyzer
      sqls
      tofu-ls
      vscode-json-languageserver
      yaml-language-server
    ]);

  # --------------------
  # Dotfiles
  # --------------------
  home.file = {
    # dot_config
    ".config/sway".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/sway";
    ".config/mango".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/mango";
    ".config/jay".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/jay";
    ".config/swaylock".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/swaylock";
    ".config/kanshi".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/kanshi";
    ".config/dunst".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/dunst";
    ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/waybar";
    ".config/i3status-rs".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/i3status-rs";
    ".config/wl-tray-bridge".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/wl-tray-bridge";
    ".config/foot".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/foot";
    ".config/fish/config.fish".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/fish/config.fish";
    ".config/fish/functions".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/fish/functions";
    ".config/fish/themes".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/fish/themes";
    ".config/tmux".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/tmux";
    ".config/herdr/config.toml".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/herdr/config.toml";
    ".config/git".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/git";
    ".config/btop".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/btop";
    ".config/fuzzel".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/fuzzel";
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/nvim";
    ".config/sioyek".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/sioyek";
    ".config/devpod".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/devpod";
    ".config/darkman".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/darkman";
    ".config/helix".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/helix";
    ".config/mimeapps.list".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/mime/mimeapps.list";
    ".config/imv".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/imv";
    # dot_local
    ".local/bin".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_local/bin";
    ".local/wallpaper".source = config.lib.file.mkOutOfStoreSymlink "${hmPath}/wallpaper";
    ".local/icons".source = config.lib.file.mkOutOfStoreSymlink "${hmPath}/icons";
    ".local/share/themes/Adwaita-dark".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_local/share/Adwaita-dark";
    ".local/share/darkman".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_local/share/darkman";
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
      "git/envrc" = {
        path = "${home}/git/.envrc";
        mode = "0600";
      };

      # Gitlab
      "git/gitlab.com/config" = {
        path = "${home}/git/gitlab.com/.gitconfig";
        mode = "0640";
      };
      "git/gitlab.com/envrc" = {
        path = "${home}/git/gitlab.com/.envrc";
        mode = "0600";
      };
      "git/gitlab.com/devpod.env" = {
        path = "${home}/git/gitlab.com/.devpod.env";
        mode = "0600";
      };
      "git/gitlab.com/strobel-iac/envrc" = {
        path = "${home}/git/gitlab.com/strobel-iac/.envrc";
        mode = "0600";
      };

      # Github
      "git/github.com/config" = {
        path = "${home}/git/github.com/.gitconfig";
        mode = "0640";
      };
      "git/github.com/envrc" = {
        path = "${home}/git/github.com/.envrc";
        mode = "0600";
      };
      "git/github.com/devpod.env" = {
        path = "${home}/git/github.com/.devpod.env";
        mode = "0600";
      };

      # Codeberg
      "git/codeberg.org/config" = {
        path = "${home}/git/codeberg.org/.gitconfig";
        mode = "0640";
      };
      "git/codeberg.org/envrc" = {
        path = "${home}/git/codeberg.org/.envrc";
        mode = "0600";
      };
      "git/codeberg.org/devpod.env" = {
        path = "${home}/git/codeberg.org/.devpod.env";
        mode = "0600";
      };

      # Git Work
      "git/work/config" = {
        path = "${home}/git/work/.gitconfig";
        mode = "0640";
      };
      "git/work/envrc" = {
        path = "${home}/git/work/.envrc";
        mode = "0600";
      };
      "git/work/devpod.env" = {
        path = "${home}/git/work/.devpod.env";
        mode = "0600";
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
      "ssh/keys/id_ed25519_sk_01/private" = {
        path = "${home}/.ssh/id_ed25519_sk_01";
        mode = "0600";
      };
      "ssh/keys/id_ed25519_sk_01/public" = {
        path = "${home}/.ssh/id_ed25519_sk_01.pub";
        mode = "0644";
      };
      "ssh/keys/id_ed25519_sk_02/private" = {
        path = "${home}/.ssh/id_ed25519_sk_02";
        mode = "0600";
      };
      "ssh/keys/id_ed25519_sk_02/public" = {
        path = "${home}/.ssh/id_ed25519_sk_02.pub";
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

      # GPG
      "dot_gnupg/trustdb.gpg" = {
        sopsFile = "${secretsPath}/dot_gnupg/trustdb.gpg";
        format = "binary";
        path = "${home}/.gnupg/trustdb.gpg";
        mode = "0600";
      };
      "dot_gnupg/pubring.kbx" = {
        sopsFile = "${secretsPath}/dot_gnupg/pubring.kbx";
        format = "binary";
        path = "${home}/.gnupg/pubring.kbx";
        mode = "0644";
      };
      "dot_gnupg/openpgp-revocs.d/268A15DFB1343D1BB2C0C86C687AB1C780B9DC43.rev" = {
        sopsFile = "${secretsPath}/dot_gnupg/openpgp-revocs.d/268A15DFB1343D1BB2C0C86C687AB1C780B9DC43.rev";
        format = "binary";
        path = "${home}/.gnupg/openpgp-revocs.d/268A15DFB1343D1BB2C0C86C687AB1C780B9DC43.rev";
        mode = "0600";
      };
      "dot_gnupg/private-keys-v1.d/ACFAF84F63CC38CB371CFB5FDE8B648A43492937.key" = {
        sopsFile = "${secretsPath}/dot_gnupg/private-keys-v1.d/ACFAF84F63CC38CB371CFB5FDE8B648A43492937.key";
        format = "binary";
        path = "${home}/.gnupg/private-keys-v1.d/ACFAF84F63CC38CB371CFB5FDE8B648A43492937.key";
        mode = "0600";
      };
      "dot_gnupg/private-keys-v1.d/FCC33CBD2D0876B8245020D404C698275267909B.key" = {
        sopsFile = "${secretsPath}/dot_gnupg/private-keys-v1.d/FCC33CBD2D0876B8245020D404C698275267909B.key";
        format = "binary";
        path = "${home}/.gnupg/private-keys-v1.d/FCC33CBD2D0876B8245020D404C698275267909B.key";
        mode = "0600";
      };

      # Browser extension config
      "browser/extensions/dark_reader.json" = {
        path = "${home}/.config/dark_reader_config.json";
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
  };

  # --------------------
  # XDG
  # --------------------
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = true;
    };
    mime.enable = true;
    mimeApps.enable = false;
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
      mkdir -p ${config.home.homeDirectory}/git/codeberg.org/d-strobel
      mkdir -p ${config.home.homeDirectory}/git/work

      # Dotfiles repository
      DOTFILES_DIR=${dotfilesPath}
      DOTFILES_REPO="https://github.com/d-strobel/dotfiles.git"

      if [ ! -d "$DOTFILES_DIR/.git" ]; then
        echo "Cloning dotfiles repository..."
        ${pkgs.git}/bin/git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
      fi
    '';

  # --------------------
  # Systemd services
  # --------------------
  systemd.user.services = {
    # Clipboard service
    wl-clip-persist = {
      Unit = {
        Description = "Persistent clipboard for Wayland";
        Documentation = ["https://github.com/Linus789/wl-clip-persist"];
        After = ["graphical-session.target"];
        Wants = ["graphical-session.target"];
      };
      Service = {
        ExecStart = "${pkgs.wl-clip-persist}/bin/wl-clip-persist --clipboard regular";
        Type = "simple";
        Restart = "always";
      };
      Install = {
        WantedBy = ["default.target"];
      };
    };

    # Auto dark/light theme
    darkman = {
      Unit = {
        Description = "A framework for dark-mode and light-mode transitions on Unix-like desktops.";
        Documentation = ["https://gitlab.com/WhyNotHugo/darkman"];
        After = ["graphical-session.target"];
        Wants = ["graphical-session.target"];
      };
      Service = {
        ExecStart = "${pkgs.darkman}/bin/darkman run";
        Type = "simple";
        Restart = "always";
        Environment = [
          "XDG_DATA_DIRS=${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:/run/current-system/sw/share"
        ];
      };
      Install = {
        WantedBy = ["default.target"];
      };
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

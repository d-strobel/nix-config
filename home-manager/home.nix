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
      # inputs.neovim-nightly.packages.${pkgs.stdenv.hostPlatform.system}.default

      # Helium Browser
      inputs.helium-browser.packages.${pkgs.stdenv.hostPlatform.system}.default

      # Devpod (fork)
      devpod
    ]
    ++ (with pkgs; [
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
      sioyek
      librepods
      keepassxc
      tutanota-desktop
      zennotes-desktop

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

      # Screenshot tools
      satty

      # Notifications
      dunst

      # Time-based dark/light theme
      darkman

      # Status Bar
      waybar

      # Fonts
      font-awesome
      jetbrains-mono
      nerd-fonts.jetbrains-mono

      # Clipboard
      wl-clipboard-rs
      wl-clip-persist

      # Application launcher
      fuzzel

      # Neovim dependencies
      neovim
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

      # Helix
      steelix
      steel
    ]);

  # --------------------
  # Dotfiles
  # --------------------
  home.file = {
    # dot_config
    ".config/sway".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/sway";
    ".config/swaylock".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/swaylock";
    ".config/kanshi".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/kanshi";
    ".config/dunst".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/dunst";
    ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/waybar";
    ".config/foot".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/foot";
    ".config/fish/config.fish".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/fish/config.fish";
    ".config/fish/functions".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/fish/functions";
    ".config/fish/themes".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/fish/themes";
    ".config/tmux".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/tmux";
    ".config/git".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/git";
    ".config/btop".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/btop";
    ".config/fuzzel".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/fuzzel";
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/nvim";
    ".config/sioyek".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/sioyek";
    ".config/devpod".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/devpod";
    ".config/darkman".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/darkman";
    ".config/zennotes".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/zennotes";
    ".config/helix".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot_config/helix";
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
  # Firefox
  # --------------------
  programs.firefox = let
    # Helper variables for preferences
    lockFalse = {
      Value = false;
      Status = "locked";
    };
    lockTrue = {
      Value = true;
      Status = "locked";
    };
  in {
    enable = true;
    package = with pkgs; firefox;
    configPath = "${config.xdg.configHome}/mozilla/firefox";

    languagePacks = [
      "en-US"
      "de"
    ];

    # More information -> about:policies#documentation
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DisableAccounts = true;
      DisableFirefoxScreenshots = true;
      DisableProfileImport = true;
      DisableMasterPasswordCreation = true;
      PasswordManagerEnabled = false;
      OfferToSaveLoginsDefault = false;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DontCheckDefaultBrowser = true;
      DisplayBookmarksToolbar = "newtab"; # alternatives: "always" or "newtab"
      DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
      SearchBar = "unified"; # alternative: "separate"
      DNSOverHTTPS = {
        Enabled = true;
        ProviderURL = "https://doh.libredns.gr/dns-query";
        Locked = true;
        Fallback = true;
      };
      EncryptedMediaExtensions = {
        Enabled = true;
        Locked = true;
      };

      # Check about:config for options.
      Preferences = {
        "browser.contentblocking.category" = {
          Value = "strict";
          Status = "locked";
        };
        "extensions.pocket.enabled" = lockFalse;
        "extensions.screenshots.disabled" = lockTrue;
        "browser.topsites.contile.enabled" = lockFalse;
        "browser.formfill.enable" = lockFalse;
        "browser.search.suggest.enabled" = lockFalse;
        "browser.search.suggest.enabled.private" = lockFalse;
        "browser.urlbar.suggest.searches" = lockFalse;
        "browser.urlbar.showSearchSuggestionsFirst" = lockFalse;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = lockFalse;
        "browser.newtabpage.activity-stream.feeds.snippets" = lockFalse;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = lockFalse;
        "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lockFalse;
        "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lockFalse;
        "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lockFalse;
        "browser.newtabpage.activity-stream.showSponsored" = lockFalse;
        "browser.newtabpage.activity-stream.system.showSponsored" = lockFalse;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = lockFalse;
        "browser.translations.automaticallyPopup" = lockFalse;
        "browser.uitour.enabled" = lockFalse;
        # "browser.uiCustomization.state" = {
        #   Value = "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[\"_testpilot-containers-browser-action\",\"_88ebde3a-4581-4c6b-8019-2a05a9e3e938_-browser-action\",\"_762f9885-5a13-4abd-9c77-433dcd38b8fd_-browser-action\"],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"customizableui-special-spring1\",\"vertical-spacer\",\"urlbar-container\",\"customizableui-special-spring2\",\"downloads-button\",\"fxa-toolbar-menu-button\",\"unified-extensions-button\",\"addon_darkreader_org-browser-action\",\"ublock0_raymondhill_net-browser-action\",\"addon_simplelogin-browser-action\",\"_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action\",\"reset-pbm-toolbar-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"firefox-view-button\",\"tabbrowser-tabs\",\"new-tab-button\"],\"vertical-tabs\":[],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"developer-button\",\"addon_darkreader_org-browser-action\",\"ublock0_raymondhill_net-browser-action\",\"screenshot-button\",\"_testpilot-containers-browser-action\",\"addon_simplelogin-browser-action\",\"_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action\",\"_88ebde3a-4581-4c6b-8019-2a05a9e3e938_-browser-action\",\"_762f9885-5a13-4abd-9c77-433dcd38b8fd_-browser-action\",\"reset-pbm-toolbar-button\"],\"dirtyAreaCache\":[\"nav-bar\",\"vertical-tabs\",\"PersonalToolbar\",\"toolbar-menubar\",\"TabsToolbar\",\"unified-extensions-area\"],\"currentVersion\":23,\"newElementCount\":2}";
        #   Status = "locked";
        # };
        "network.protocol-handler.external.mailto" = lockFalse;
      };

      # Set extensions
      ExtensionSettings = {
        # Block everything but the extensions definded below
        "*".installation_mode = "blocked";

        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
          default_area = "menupanel";
        };
        # Dark reader
        "addon@darkreader.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = false;
          default_area = "menupanel";
        };
        # Firefox Containers
        "@testpilot-containers" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/@testpilot-containers/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = false;
          default_area = "menupanel";
        };
        # Bitwarden
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/{446900e4-71c2-419f-a6a7-df9c091e268b}/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = false;
          default_area = "navbar";
        };
        # Simplelogin
        "addon@simplelogin" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/addon@simplelogin/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = false;
          default_area = "navbar";
        };
        # Return YouTube dislike
        "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/{762f9885-5a13-4abd-9c77-433dcd38b8fd}/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = false;
          default_area = "menupanel";
        };
        # Hide YouTube shorts
        "{88ebde3a-4581-4c6b-8019-2a05a9e3e938}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/{88ebde3a-4581-4c6b-8019-2a05a9e3e938}/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = false;
          default_area = "menupanel";
        };
        # Youtube SponsorBlock
        "sponsorBlocker@ajay.app" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorBlocker@ajay.app/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = false;
          default_area = "menupanel";
        };
        # Vimium
        "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/{d7742d87-e61d-4b78-b8a1-b469842139fa}/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = false;
          default_area = "menupanel";
        };
      };
    };

    # Betterfox (user.js) integration
    betterfox = {
      enable = true;
      version = "150.0";

      # Must be equal to firefox profiles module
      profiles.default = {
        enableAllSections = true;
      };
    };

    # Define profiles
    profiles = {
      default = {
        id = 0;
        name = "Default";

        containersForce = true;
        containers = {
          laser = {
            id = 1;
            name = "Laser";
            color = "green";
            icon = "circle";
          };
          google = {
            id = 2;
            name = "Google";
            color = "yellow";
            icon = "circle";
          };
          vault = {
            id = 3;
            name = "Vault";
            color = "red";
            icon = "circle";
          };
          meta = {
            id = 4;
            name = "Meta";
            color = "blue";
            icon = "circle";
          };
          discord = {
            id = 5;
            name = "Discord";
            color = "purple";
            icon = "circle";
          };
        };

        search = {
          default = "Kagi";
          privateDefault = "ddg";
          force = true;

          engines = {
            "Kagi" = {
              urls = [{template = "https://kagi.com/search?q={searchTerms}";}];
              icon = "${config.home.homeDirectory}/.local/icons/kagi.svg";
              definedAliases = ["@k" "@K"];
            };

            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];

              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@np"];
            };

            bing.metaData.hidden = true;
            google.metaData.hidden = true;
          };
        };

        bookmarks = {
          force = true;
          settings = [
            {
              name = "Toolbar";
              toolbar = true;
              bookmarks = [
                # Define Toolbar bookmarks here
                {
                  name = "Tuta Mail";
                  url = "https://app.tuta.com";
                }
                {
                  name = "Github";
                  url = "https://github.com";
                }
                {
                  name = "Gitlab";
                  url = "https://gitlab.com/strobel-iac";
                }
                {
                  name = "Codeberg";
                  url = "https://codeberg.org";
                }
                {
                  name = "Hacker News";
                  url = "https://news.ycombinator.com";
                }
                {
                  name = "MyNixOS (Options)";
                  url = "https://mynixos.com/";
                }
                {
                  name = "Nixhub (Versions)";
                  url = "https://www.nixhub.io/";
                }
                {
                  name = "ChatGPT";
                  url = "https://chatgpt.com/";
                }
                {
                  name = "Youtube";
                  url = "https://www.youtube.com/";
                }
                {
                  name = "Plex";
                  url = "https://app.plex.tv/";
                }
              ];
            }
          ];
        };
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
    mimeApps = {
      enable = true;
      defaultApplications = {
        "image/jpeg" = "imv.desktop";
        "image/png" = "imv.desktop";
        "text/plain" = "org.gnome.TextEditor.desktop";
        "text/html" = "org.gnome.TextEditor.desktop";
        "text/csv" = "org.gnome.TextEditor.desktop";
        "application/pdf" = ["sioyek.desktop"];
        "application/zip" = "engrampa.desktop";
        "application/x-tar" = "engrampa.desktop";
        "application/x-bzip2" = "engrampa.desktop";
        "application/x-gzip" = "engrampa.desktop";
        "x-scheme-handler/http" = ["librewolf.desktop" "chromium-browser.desktop"];
        "x-scheme-handler/https" = ["librewolf.desktop" "chromium-browser.desktop"];
        "x-scheme-handler/about" = ["librewolf.desktop" "chromium-browser.desktop"];
        "x-scheme-handler/unknown" = ["librewolf.desktop" "chromium-browser.desktop"];
        "audio/mp3" = "vlc.desktop";
        "audio/x-matroska" = "vlc.desktop";
        "video/webm" = "vlc.desktop";
        "video/mp4" = "vlc.desktop";
        "video/x-matroska" = "vlc.desktop";
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

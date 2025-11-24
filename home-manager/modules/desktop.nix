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
  # Package installation goes here
  home.packages = with pkgs; [
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
  ];

  home.file = mkSymlinkAttrs {
    # Wayland Compositor - Niri
    ".config/niri" = {
      source = ../dotfiles/niri;
      outOfStoreSymlink = true;
      recursive = true;
    };

    # Notifications - Dunst
    ".config/dunst/dunstrc" = {
      source = ../dotfiles/dunst/dunstrc;
      outOfStoreSymlink = true;
      recursive = false;
    };

    # Status Bar - Waybar
    ".config/waybar" = {
      source = ../dotfiles/waybar;
      outOfStoreSymlink = true;
      recursive = true;
    };
  };

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

  # QT Theming
  qt = {
    enable = true;
    platformTheme = {
      name = "gtk";
    };
    style = {
      name = "qt6gtk2";
      package = with pkgs; adwaita-qt;
    };
  };

  # GTK Theming
  gtk = {
    enable = true;
    font = {
      name = "Jetbrains Mono";
      size = 11;
    };

    theme = {
      name = "adw-gtk3-dark";
      package = with pkgs; adw-gtk3;
    };

    gtk2.extraConfig = ''
      gtk-icon-theme-name="adw-gtk3-dark"
    '';

    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  home.sessionVariables.GTK_THEME = "adw-gtk3-dark";

  # Cursor Theming
  home.pointerCursor = let
    name = "BreezeX-RosePine";
    version = "1.1.0";
    hash = "sha256-t5xwAPGhuQUfGThedLsmtZEEp1Ljjo3Udhd5Ql3O67c=";
  in {
    gtk.enable = true;
    x11.enable = true;
    name = "${name}";
    size = 24;
    package = pkgs.runCommand "moveUp" {} ''
      mkdir -p $out/share/icons
      ln -s ${pkgs.fetchzip {
        url = "https://github.com/rose-pine/cursor/releases/download/v${version}/BreezeX-RosePine-Linux.tar.xz";
        hash = "${hash}";
      }} $out/share/icons/${name}
    '';
  };

  # DConf
  dconf.settings = {
    # GTK settings
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };

    # Libvirt config
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  # XDG
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };

    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "image/jpeg" = "org.gnome.Loupe.desktop";
        "image/png" = "org.gnome.Loupe.desktop";
        "text/plain" = "org.gnome.TextEditor.desktop";
        "text/html" = "org.gnome.TextEditor.desktop";
        "text/csv" = "org.gnome.TextEditor.desktop";
        "application/pdf" = ["org.pwmt.zathura.desktop" "librewolf.desktop" "chromium-browser.desktop"];
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
}

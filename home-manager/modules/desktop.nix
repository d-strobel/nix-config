{
  pkgs,
  ...
}:{
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
  };
}

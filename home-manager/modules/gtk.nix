{pkgs, ...}: {
  gtk = {
    enable = true;
    font = {
      name = "Jetbrains Mono";
      size = 11;
    };

    theme = {
      name = "Adwaita-Dark";
      package = with pkgs; gnome-themes-extra;
    };

    gtk2.extraConfig = ''
      gtk-icon-theme-name="Adwaita-Dark"
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

  home.sessionVariables.GTK_THEME = "Adwaita-Dark";

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
}

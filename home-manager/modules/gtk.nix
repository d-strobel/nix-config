{pkgs, ...}: {
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
}

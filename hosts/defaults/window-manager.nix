{pkgs, ...}: {
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
  security.pam.services.hyprlock = {};

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd Hyprland";
      };
    };
  };

  # Enable xdg-desktop-portal
  xdg.portal.enable = true;

  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  # Automount
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # DBus
  services.dbus = {
    enable = true;
    packages = with pkgs; [dconf];
  };
  programs.dconf.enable = true;
}

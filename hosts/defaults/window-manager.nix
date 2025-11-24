{pkgs, ...}: {
  # Login greeter (TUI)
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
      };
    };
  };

  # xdg-desktop-portal
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
  };

  # Extra packages
  environment.systemPackages = with pkgs; [
    wayland-utils
    xwayland-satellite
    wineWowPackages.waylandFull
    parted
    vim
    hardinfo2
  ];

  # Wayland Compositor - MangoWC
  programs.mango.enable = true;

  # Wayland Compositor - Niri
  programs.niri = {
    enable = true;
    package = with pkgs; niri;
  };

  # Keyrings
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

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

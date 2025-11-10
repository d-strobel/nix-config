{pkgs, ...}: {
  # Additional system packages
  environment.systemPackages = with pkgs; [
    parted
    vim
    wineWowPackages.waylandFull
    hardinfo2
    wayland-utils
  ];
}

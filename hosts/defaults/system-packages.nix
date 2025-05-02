{pkgs, ...}: {
  # Additional system packages
  environment.systemPackages = with pkgs; [
    parted
    vim
    wineWowPackages.waylandFull
    uutils-coreutils-noprefix
  ];

  # Add ladybird browser
  programs.ladybird.enable = true;
}

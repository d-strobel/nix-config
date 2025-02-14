{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # Desktop apps
    obsidian
    signal-desktop
    nautilus
    gnome-disk-utility
    overskride
    networkmanagerapplet
    pavucontrol
    vlc
    sums
    gnome-font-viewer

    # CLI tools
    ffmpeg
    ripgrep
    fd
    unzip
    zip
    wget
    wl-clipboard
    playerctl
    brightnessctl

    # Screenshot tools
    grim
    slurp
    satty

    # Compiler stuff
    # libgcc
    # libgccjit
    # bintools

    # Window-Manager tools
    hyprpolkitagent
    libsForQt5.xwaylandvideobridge
    libnotify
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
  ];
}

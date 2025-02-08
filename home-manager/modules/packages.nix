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

    # CLI tools
    ffmpeg
    ripgrep
    fd
    unzip
    zip
    wget
    wl-clipboard
    grim
    slurp
    playerctl

    # Compiler stuff
    libgcc
    libgccjit
    bintools

    # Window-Manager tools
    nwg-look
    hyprpolkitagent
    libsForQt5.xwaylandvideobridge
    libnotify
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
  ];
}

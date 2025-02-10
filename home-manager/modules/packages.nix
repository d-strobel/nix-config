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

    # Cosmic apps
    cosmic-edit
    cosmic-icons
    cosmic-files
    cosmic-player
    cosmic-settings
    cosmic-launcher
    xdg-desktop-portal-cosmic
    pop-launcher

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
    hyprpolkitagent
    libsForQt5.xwaylandvideobridge
    libnotify
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
  ];
}

{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # Desktop apps
    obsidian
    signal-desktop

    # CLI tools
    ffmpeg
    btop
    ripgrep
    unzip
    zip
    wget
    wl-clipboard
    grim
    slurp

    # Window-Manager tools
    libsForQt5.xwaylandvideobridge
    libnotify
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
  ];
}

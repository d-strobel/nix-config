{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # Desktop apps
    obsidian
    signal-desktop
    overskride
    networkmanagerapplet
    pavucontrol
    vlc
    openfortivpn
    remmina
    gnome-disk-utility
    gnome-calculator
    winbox
    localsend
    rustdesk
    sniffnet

    # CLI tools
    dig
    ffmpeg
    ripgrep
    fd
    unzip
    zip
    wget
    wl-clipboard
    playerctl
    brightnessctl
    wavemon
    openssl

    # Screenshot tools
    grim
    slurp
    satty

    # Window-Manager tools
    hyprpolkitagent
    libsForQt5.xwaylandvideobridge
    libnotify
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
  ];
}

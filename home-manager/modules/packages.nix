{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # Desktop apps
    obsidian
    signal-desktop
    pavucontrol
    vlc
    openfortivpn
    gnome-disk-utility
    gnome-calculator
    winbox
    localsend
    rustdesk
    sniffnet
    brave

    # CLI tools
    dig
    ffmpeg
    ripgrep
    fd
    unzip
    zip
    wget
    playerctl
    brightnessctl
    wavemon
    openssl
    ipcalc

    # Screenshot tools
    grim
    slurp
    satty

    # Window-Manager tools
    hyprpolkitagent
    libsForQt5.xwaylandvideobridge
    libnotify
  ];
}

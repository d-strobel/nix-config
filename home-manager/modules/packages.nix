{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # Desktop apps
    obsidian
    signal-desktop
    nautilus
    overskride
    networkmanagerapplet
    pavucontrol
    vlc
    openfortivpn
    remmina
    loupe
    gnome-disk-utility
    gnome-calendar
    gnome-calculator
    gnome-clocks
    gnome-text-editor
    microsoft-edge
    cosmic-edit
    cosmic-files
    winbox

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

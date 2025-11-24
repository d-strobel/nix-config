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
    gnome-system-monitor
    winbox
    localsend
    brave
    nautilus

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
    libnotify
    wmenu
    swaylock
  ];

  programs.btop = {
    enable = true;
    package = with pkgs; btop;
    settings = {
      color_theme = "Default";
      theme_background = false;
    };
  };
}

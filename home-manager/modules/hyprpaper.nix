{pkgs, ...}: {
  services.hyprpaper = {
    enable = true;
    package = with pkgs; hyprpaper;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      preload = [
        "/home/dstrobel/.config/wallpapers/nixos-01.jpg"
        "/home/dstrobel/.config/wallpapers/nixos-02.jpg"
        "/home/dstrobel/.config/wallpapers/waifu-01.jpg"
      ];

      wallpaper = [
        ",/home/dstrobel/.config/wallpapers/nixos-02.jpg"
      ];
    };
  };

  home.file.".config/wallpapers" = {
    enable = true;
    source = ../wallpapers;
    recursive = true;
  };
}

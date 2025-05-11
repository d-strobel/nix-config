{
  pkgs,
  config,
  ...
}: {
  services.hyprpaper = {
    enable = true;
    package = with pkgs; hyprpaper;

    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      preload = [
        "${config.home.homeDirectory}/.config/wallpapers/nixos-01.jpg"
        "${config.home.homeDirectory}/.config/wallpapers/nixos-02.jpg"
        "${config.home.homeDirectory}/.config/wallpapers/waifu-01.jpg"
        "${config.home.homeDirectory}/.config/wallpapers/bg-01.jpg"
        "${config.home.homeDirectory}/.config/wallpapers/bg-02.jpg"
      ];

      wallpaper = [
        ",${config.home.homeDirectory}/.config/wallpapers/bg-02.jpg"
      ];
    };
  };

  home.file.".config/wallpapers" = {
    enable = true;
    source = ../wallpapers;
    recursive = true;
  };
}

{
  pkgs,
  config,
  ...
}: {
  services.hyprpaper = let
    wallpaper = "landscape-01.jpg";
  in {
    enable = true;
    package = with pkgs; hyprpaper;

    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      preload = [
        "${config.home.homeDirectory}/.config/wallpapers/${wallpaper}"
      ];

      wallpaper = [
        ",${config.home.homeDirectory}/.config/wallpapers/${wallpaper}"
      ];
    };
  };

  home.file.".config/wallpapers" = {
    enable = true;
    source = ../wallpapers;
    recursive = true;
  };
}

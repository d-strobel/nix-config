{pkgs, ...}: {
  home.packages = with pkgs; [
    hyprnotify
  ];

  systemd.user.services.hyprnotify = let
    hyprnotify = "${pkgs.hyprnotify}/bin/hyprnotify";
  in {
    Unit = {
      Description = "DBus Implementation for hyprctl notify";
      Documentation = "https://github.com/codelif/hyprnotify";
      Requires = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${hyprnotify} --font-size 20 --no-sound";
      Type = "simple";
      Restart = "always";
      RestartSec = 10;
    };
  };
}

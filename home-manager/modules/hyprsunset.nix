{pkgs, ...}: {
  home.packages = with pkgs; [
    hyprsunset
  ];

  systemd.user.services = let
    hyprsunset = "${pkgs.hyprsunset}/bin/hyprsunset";
  in {
    hyprsunset = {
      Unit = {
        Description = "Blue-light filter on Hyprland.";
        Documentation = "https://wiki.hyprland.org/Hypr-Ecosystem/hyprsunset";
        PartOf = ["graphical-session.target"];
        Requires = ["graphical-session.target"];
        After = ["graphical-session.target"];
        Wants = ["hyprsunset.timer"];
      };

      Service = {
        ExecStart = "${hyprsunset} -t 5500";
        ExecStop = "pgrep hyprsunset && pkill hyprsunset";
        Type = "simple";
        Restart = "on-failure";
      };
    };
  };

  systemd.user.timers = {
    hyprsunset = {
      Unit = {
        Description = "Blue-light filter on Hyprland.";
        Documentation = "https://wiki.hyprland.org/Hypr-Ecosystem/hyprsunset";
      };

      Timer = {
        OnCalendar = "*-*-* 22:00:00";
        Persistent = true;
      };
      Install.WantedBy = ["timers.target"];
    };
  };
}

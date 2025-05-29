{pkgs, ...}: {
  home.packages = with pkgs; [
    wl-clipboard-rs
    wl-clip-persist
  ];

  systemd.user.services.wl-clip-persist = let
    wlClipPersist = "${pkgs.wl-clip-persist}/bin/wl-clip-persist";
  in {
    Unit = {
      Description = "Persistent clipboard for Wayland";
      Documentation = "https://github.com/Linus789/wl-clip-persist";
      Requires = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${wlClipPersist} --clipboard regular";
      Type = "simple";
      Restart = "always";
    };
  };
}

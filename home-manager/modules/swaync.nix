{pkgs, ...}: {
  services.swaync = {
    enable = true;
    package = with pkgs; swaynotificationcenter;
  };
}

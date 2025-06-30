{pkgs, ...}: {
  services.shikane = {
    enable = true;
    package = with pkgs; shikane;
  };
}

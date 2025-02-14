{pkgs, ...}: {
  programs.fish = {
    enable = true;
    package = with pkgs; fish;
  };
}

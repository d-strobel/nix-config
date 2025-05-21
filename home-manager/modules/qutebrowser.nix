{pkgs, ...}: {
  programs.qutebrowser = {
    enable = true;
    package = with pkgs; qutebrowser;
  };
}

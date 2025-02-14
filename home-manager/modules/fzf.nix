{pkgs, ...}: {
  programs.fzf = {
    enable = true;
    package = with pkgs; fzf;
    enableFishIntegration = true;
  };
}

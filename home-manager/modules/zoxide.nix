{pkgs, ...}: {
  programs.zoxide = {
    enable = true;
    package = with pkgs; zoxide;
    enableFishIntegration = true;
    options = [
      "--cmd cd"
    ];
  };
}

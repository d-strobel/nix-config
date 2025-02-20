{pkgs, ...}: {
  programs.eza = {
    enable = true;
    package = with pkgs; eza;
    enableFishIntegration = true;
    colors = "always";
    git = true;
    icons = "always";
    extraOptions = [
      "--group-directories-first"
      "--group"
      "--header"
    ];
  };
}

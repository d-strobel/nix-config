{pkgs, ...}: {
  programs.starship = {
    enable = true;
    package = with pkgs; starship;
    enableFishIntegration = true;
  };

  home.file.".config/starship.toml" = {
    enable = true;
    source = ../dotfiles/starship.toml;
  };
}

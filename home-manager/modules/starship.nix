{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  home.file.".config/starship.toml" = {
    enable = true;
    source = ../dotfiles/starship.toml;
  };
}

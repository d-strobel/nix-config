{pkgs, ...}: {
  home.packages = with pkgs; [
    cosmic-edit
    cosmic-files
  ];

  # Rose-Pine dark theme
  home.file."./.config/cosmic/com.system76.CosmicTheme.Dark" = {
    enable = true;
    source = ../dotfiles/cosmic/com.system76.CosmicTheme.Dark;
    recursive = true;
  };

  # Cosmic editor config
  home.file."./.config/cosmic/com.system76.CosmicEdit" = {
    enable = true;
    source = ../dotfiles/cosmic/com.system76.CosmicEdit;
    recursive = true;
  };
}

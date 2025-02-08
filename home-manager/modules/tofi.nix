{pkgs,...}:
{
  home.packages = with pkgs; [
    tofi
  ];

  home.file."./.config/tofi" = {
    enable = true;
    source = ../dotfiles/tofi;
    recursive = true;
  };
}

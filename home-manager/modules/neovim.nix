{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    extraPackages = with pkgs; [
      nixd
      alejandra
    ];
  };

  home.file."./.config/nvim" = {
    enable = true;
    source = ../dotfiles/nvim;
    recursive = true;
  };
}

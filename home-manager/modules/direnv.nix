{pkgs, ...}: {
  programs.direnv = {
    enable = true;
    package = with pkgs; direnv;

    nix-direnv = {
      enable = true;
      package = with pkgs; nix-direnv;
    };
  };
}

{pkgs, ...}: {
  home.packages = with pkgs; [
    font-awesome
    jetbrains-mono
    nerd-fonts.jetbrains-mono
  ];
}

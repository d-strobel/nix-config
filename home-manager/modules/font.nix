{pkgs, ...}: {
  home.packages = with pkgs; [
    jetbrains-mono
    font-awesome
  ];
}

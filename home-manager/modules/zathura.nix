{pkgs, ...}: {
  programs.zathura = {
    enable = true;
    package = with pkgs; zathura;
    options = {
      font = "JetBrainsMono NF";
    };
  };
}

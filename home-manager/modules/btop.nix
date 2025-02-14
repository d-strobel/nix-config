{pkgs, ...}: {
  programs.btop = {
    enable = true;
    package = with pkgs; btop;
    settings = {
      color_theme = "Default";
      theme_background = false;
    };
  };
}

{pkgs, ...}: {
  programs.ghostty = {
    enable = true;
    package = with pkgs; ghostty;
    enableFishIntegration = true;
    settings = {
      # Theme and colors
      theme = "rose-pine";
      cursor-invert-fg-bg = true;
      background = "#131021";
      background-opacity = 0.5;

      # Window
      window-decoration = false;
      window-padding-x = 10;
      window-padding-y = 10;

      # Mouse
      mouse-hide-while-typing = true;
    };
  };
}

{pkgs, ...}: {
  programs.alacritty = {
    enable = true;
    package = with pkgs; alacritty;
    settings = {
      env = {
        TERM = "xterm-256color";
      };

      window = {
        padding.x = 6;
        padding.y = 6;
        dynamic_padding = true;
        opacity = 1.0;
      };

      mouse = {
        hide_when_typing = true;
      };

      font = let
        fontName = "JetBrainsMono NF";
      in {
        size = 16;
        normal.family = "${fontName}";
        bold.family = "${fontName}";
        italic.family = "${fontName}";
        bold_italic.family = "${fontName}";
      };

      colors.primary = {
        background = "#131021";
      };

      colors.normal = {
        black = "#26233a";
        red = "#eb6f92";
        green = "#31748f";
        yellow = "#f6c177";
        blue = "#9ccfd8";
        magenta = "#c4a7e7";
        cyan = "#ebbcba";
        white = "#e0def4";
      };
    };
  };
}

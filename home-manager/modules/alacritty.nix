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
        size = 18;
        normal.family = "${fontName}";
        bold.family = "${fontName}";
        italic.family = "${fontName}";
        bold_italic.family = "${fontName}";
      };

      colors.primary = {
        background = "#0e1415";
      };

      colors.normal = {
        black = "#000000";
        red = "#d2322d";
        green = "#6abf40";
        yellow = "#cd974b";
        blue = "#217EBC";
        magenta = "#9B3596";
        cyan = "#178F79";
        white = "#cecece";
      };
    };
  };
}

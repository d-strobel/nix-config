{
  programs.alacritty = {
    enable = true;
    settings = {
      env = {
        TERM = "xterm-256color";
      };

      window = {
        padding.x = 6;
        padding.y = 6;
        dynamic_padding = true;
      };

      mouse = {
        hide_when_typing = true;
      };

      font = {
        size = 11;
        normal.family = "JetBrains Mono";
        bold.family = "JetBrains Mono";
        italic.family = "JetBrains Mono";
        bold_italic.family = "JetBrains Mono";
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

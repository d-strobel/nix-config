{
  pkgs,
  config,
  ...
}: let
  # Set the name of the theme.
  # The file must be present and staged in git to work.
  themeFileName = "rose-pine.rasi";
in {
  programs.rofi = {
    enable = true;
    package = with pkgs; rofi;
    extraConfig = {
      # Disable the following keybinds
      kb-mode-complete = "";
      kb-row-left = "";
      kb-row-right = "";
      kb-remove-to-eol = "";
      kb-remove-to-sol = "";
      kb-remove-char-forward = "";

      # Modify the following keybinds
      kb-row-up = "Up,Control+p,Control+k";
      kb-row-down = "Down,Control+n,Control+j";
      kb-accept-entry = "Control+l,Return";
      kb-page-prev = "Page_Up,Control-u";
      kb-page-next = "Page_Down,Control-d";
    };

    themeFileName = "${config.home.homeDirectory}/.config/rofi/${themeFileName}";
  };

  # themeFileName file
  home.file."./.config/rofi/${themeFileName}" = {
    enable = true;
    source = ../dotfiles/rofi/${themeFileName};
  };
}

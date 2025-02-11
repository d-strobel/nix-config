{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
      };

      background = {
        path = "/home/dstrobel/.config/wallpapers/nixos-02.jpg";
        blur_passes = 2;
        blur_size = 7;
      };

      label = [
        {
          text = "$TIME";
          shadow_passes = 1;
          shadow_boost = 0.5;
          font_size = 100;
          font_family = "JetBrains Mono";

          position = "0, 300";
          halign = "center";
          valign = "center";
        }
        {
          text = "cmd[update:43200000] echo \"$(date +\"%A, %d %B %Y\")\"";
          shadow_passes = 1;
          shadow_boost = 0.5;
          font_size = 25;
          font_family = "JetBrains Mono";

          position = "0, 180";
          halign = "center";
          valign = "center";
        }
      ];

      input-field = {
        size = "300, 50";
        outline_thickness = 1;
        dots_size = 0.1;
        dots_spacing = 0.3;

        inner_color = "rgba(00000000)";
        outer_color = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        check_color = "rgba(00ff99ee) rgba(ff6633ee) 45deg";
        fail_color = "rgba(ff6633ee) rgba(ff0066ee) 45deg";
        fade_on_empty = false;

        font_family = "JetBrains Mono";
        font_color = "rgba(ffffffff)";

        position = "0, 0";
        halign = "center";
        valign = "center";
      };
    };
  };
}

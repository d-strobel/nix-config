{pkgs, ...}: {
  home.pointerCursor = {
    name = "DMZ-Black";
    package = with pkgs; vanilla-dmz;

    gtk = {
      enable = true;
    };

    size = 24;
  };
}

{pkgs, ...}: {
  home.pointerCursor = {
    name = "Adwaita";
    package = with pkgs; adwaita-icon-theme;

    gtk = {
      enable = true;
    };

    size = 24;
  };
}

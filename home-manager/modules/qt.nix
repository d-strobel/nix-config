{pkgs, ...}: {
  qt = {
    enable = true;
    platformTheme = {
      name = "gtk";
    };
    style = {
      name = "qt6gtk2";
      package = with pkgs; adwaita-qt;
    };
  };
}

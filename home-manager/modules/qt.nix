{pkgs, ...}: {
  qt = {
    enable = true;
    platformTheme = {
      name = "gtk";
    };
    style = {
      name = "adwaita-dark";
      package = with pkgs; adwaita-qt;
    };
  };
}

{pkgs, ...}: {
  services.mako = {
    enable = true;
    package = with pkgs; mako;
    defaultTimeout = 5000;
    anchor = "top-right";
    backgroundColor = "#0A0A0FCC";
    borderRadius = 6;
    borderSize = 0;
    font = "JetBrainsMono NF";
    textColor = "#e0def4";
    height = 150;
    width = 350;
    padding = "5";
    margin = "10";
  };
}

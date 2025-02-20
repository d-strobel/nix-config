{pkgs, ...}: {
  services.mako = {
    enable = true; # Enables the Mako notification service
    package = with pkgs; mako;
    defaultTimeout = 5000; # Default timeout for notifications in milliseconds (5 seconds)
    anchor = "top-right";
    backgroundColor = "#0a0a0f";
    borderColor = "#31748f";
    borderRadius = 4;
    borderSize = 2;
    font = "JetBrainsMono NF";
    textColor = "#e0def4";
    height = 150;
    width = 350;
    padding = "5";
    margin = "10";
  };
}

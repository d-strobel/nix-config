{pkgs, ...}: {
  services.mako = {
    enable = true;
    package = with pkgs; mako;
    settings = {
      default-timeout = 5000;
      anchor = "top-right";
      background-color = "#0A0A0FCC";
      border-radius = 6;
      border-size = 0;
      font = "JetBrainsMono NF";
      text-color = "#e0def4";
      height = 150;
      width = 350;
      padding = "5";
      margin = "14";
    };
  };
}

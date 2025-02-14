{pkgs, ...}: {
  programs.k9s = {
    enable = true;
    package = with pkgs; k9s;
    skins = {
      rose-pine = ../dotfiles/k9s/skins/rose-pine.yaml;
    };
    settings = {
      k9s = {
        ui = {
          skin = "rose-pine";
        };
      };
    };
  };
}

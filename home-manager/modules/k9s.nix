{
  programs.k9s = {
    enable = true;
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

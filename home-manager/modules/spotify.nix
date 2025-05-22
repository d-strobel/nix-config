{pkgs, ...}: {
  programs.ncspot = {
    enable = true;
    package = with pkgs; ncspot;
  };

  programs.fish.shellAliases = let
    ncspot = "${pkgs.ncspot}/bin/ncspot";
  in {
    spotify = "${ncspot}";
  };

  home.file.".config/ncspot/config.toml" = {
    enable = true;
    source = ../dotfiles/ncspot/config.toml;
  };
}

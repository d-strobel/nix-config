{pkgs, ...}: {
  home.pointerCursor = let
    name = "BreezeX-RosePine";
    version = "1.1.0";
    hash = "sha256-t5xwAPGhuQUfGThedLsmtZEEp1Ljjo3Udhd5Ql3O67c=";
  in {
    gtk.enable = true;
    x11.enable = true;
    name = "${name}";
    size = 24;
    package = pkgs.runCommand "moveUp" {} ''
      mkdir -p $out/share/icons
      ln -s ${pkgs.fetchzip {
        url = "https://github.com/rose-pine/cursor/releases/download/v${version}/BreezeX-RosePine-Linux.tar.xz";
        hash = "${hash}";
      }} $out/share/icons/${name}
    '';
  };
}

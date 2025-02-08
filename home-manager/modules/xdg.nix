{config, ...}:{
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    extraConfig = {
      XDG_WORK_DIR = "${config.home.homeDirectory}/Work";
      XDG_PRIVATE_DIR = "${config.home.homeDirectory}/Private";
    };
  };
}

{pkgs, ...}: {
  programs.git = {
    enable = true;
    package = with pkgs; git;
    userName = "d-strobel";
    userEmail = "github.6f1aa@slmails.com";
    extraConfig = {
      core = {
        bare = true;
      };
    };
  };
}

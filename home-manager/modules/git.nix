{
  pkgs,
  config,
  ...
}: let
  # Github
  githubPath = "git/github.com";
  githubEmail = "github.6f1aa@slmails.com";
  githubName = "d-strobel";

  # Gitlab
  gitlabPath = "git/gitlab.com";
  gitlabEmail = "gitlab.e0ueb@slmails.com";
  gitlabName = "d-strobel";
in {
  programs.git = {
    enable = true;
    package = with pkgs; git;
    extraConfig = {
      core = {
        bare = true;
      };
      diff = {
        tool = "vimdiff";
      };
      merge = {
        tool = "vimdiff";
      };
      # Include platform specific configs
      includeIf = {
        "gitdir:~/${githubPath}/" = {
          path = "${config.home.homeDirectory}/${githubPath}/.gitconfig";
        };
        "gitdir:~/${gitlabPath}/" = {
          path = "${config.home.homeDirectory}/${gitlabPath}/.gitconfig";
        };
      };
    };
  };

  # Github gitconfig
  home.file."./${githubPath}/.gitconfig" = {
    enable = true;
    text = ''
      [user]
      email = ${githubEmail}
      name = ${githubName}
    '';
  };

  # Gitlab gitconfig
  home.file."./${gitlabPath}/.gitconfig" = {
    enable = true;
    text = ''
      [user]
      email = ${gitlabEmail}
      name = ${gitlabName}
    '';
  };
}

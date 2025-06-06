{pkgs, ...}: {
  programs.chromium = {
    enable = true;
    package = with pkgs; chromium;

    extensions = [
      # Dark Reader
      {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";}
    ];
  };
}

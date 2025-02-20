{pkgs, ...}: {
  programs.chromium = {
    enable = true;
    package = with pkgs; chromium;

    extensions = [
      # ublock Origin
      {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";}

      # Dark Reader
      {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";}
    ];
  };
}

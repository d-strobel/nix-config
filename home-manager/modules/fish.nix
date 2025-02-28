{
  pkgs,
  lib,
  ...
}: {
  programs.fish = {
    enable = true;
    package = with pkgs; fish;
    shellAliases = let
      tmux = "${pkgs.tmux}/bin/tmux";
      tmuxOpen =
        pkgs.writeShellScriptBin
        /*
        bash
        */
        "tmux-open" ''
          if [[ $PWD == $HOME ]]; then
            selected_name="scratch"
          else
            selected_name=$(basename "$PWD" | tr . _)
          fi

          tmux_running=$(pgrep tmux)

          if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
            ${tmux} new-session -s $selected_name -c $PWD
            exit 0
          fi

          if ! ${tmux} has-session -t=$selected_name 2> /dev/null; then
            ${tmux} new-session -ds $selected_name -c $PWD
          fi

          ${tmux} attach-session -t $selected_name
        '';
    in {
      tmux = "${lib.getExe tmuxOpen}";
    };

    functions = let
      openfortivpn = "${pkgs.openfortivpn}/bin/openfortivpn";
    in {
      vpn-connect = "sudo ${openfortivpn}";
      ipv6-disable = "sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1";
      ipv6-enable = "sudo sysctl -w net.ipv6.conf.all.disable_ipv6=0";
    };
  };
}

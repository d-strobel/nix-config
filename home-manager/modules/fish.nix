{
  pkgs,
  lib,
  mage-fish-completions,
  ...
}: let
  mageFishCompletions = mage-fish-completions.packages.${pkgs.system}.default;
in {
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
      t = "${lib.getExe tmuxOpen}";
      gbws = "git-branch-worktree-switch";
    };

    functions = let
      openfortivpn = "${pkgs.openfortivpn}/bin/openfortivpn";
      fzf = "${pkgs.fzf}/bin/fzf";
      git = "${pkgs.git}/bin/git";
    in {
      vpn-connect = "sudo ${openfortivpn}";
      ipv6-disable = "sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1";
      ipv6-enable = "sudo sysctl -w net.ipv6.conf.all.disable_ipv6=0";
      git-branch-worktree-switch =
        /*
        fish
        */
        ''
          # Fuzzy find all git branches
          set -l selected (${git} branch -a --format='%(refname:short)' | sort -u | ${fzf} --print-query --tmux bottom --border-label=" Git Branches ")
          if test -z "$selected"
            return
          end

          # Fzf returns 1 string:
          # Create new branch and worktree
          if test (count $selected) -eq 1; and test -n "$selected[1]"
            set -l selected_branch "$selected[1]"

            # Parse git project root directory
            set -l worktree_root (${git} worktree list | grep -E "(bare)" | awk '{print $1}')

            ${git} worktree add -b $selected_branch "$worktree_root/$selected_branch"
            cd "$worktree_root/$selected_branch"
            return
          end

          # Fzf returns 2 strings:
          # Always use the second string
          set -l selected_branch "$selected[2]"

          # Find if the branch already exists in a worktree
          set -l existing_worktree (${git} worktree list | grep -E ".*\s+\[$selected_branch\]" | awk '{print $1}')

          # If the branch is already in a worktree, cd into it
          if test -n "$existing_worktree"
            cd "$existing_worktree"
            return
          end

          # Parse git project root directory
          set -l worktree_root (${git} worktree list | grep -E "(bare)" | awk '{print $1}')

          # Checkout the remote branch to a new worktree
          ${git} worktree add "$worktree_root/$selected_branch" "$selected_branch"
          cd "$worktree_root/$selected_branch"
        '';
    };
  };

  # Link magefile target completions
  home.file.".config/fish/completions/mage.fish".source = "${mageFishCompletions}/mage.fish";
}

{
  pkgs,
  lib,
  ...
}: {
  programs.tmux = {
    enable = true;
    package = with pkgs; tmux;
    clock24 = true;
    escapeTime = 0;
    baseIndex = 1;
    keyMode = "vi";
    historyLimit = 5000;
    terminal = "screen-256color";
    mouse = true;
    shortcut = "a";

    extraConfig = let
      # Search path for tmux sessionizer
      searchPaths = "~/git/github.com/d-strobel ~/git/github.com/laser-zentrale-de ~/git/gitlab.com/strobel-iac";

      # Binaries
      tmux = "${pkgs.tmux}/bin/tmux";
      fzf = "${pkgs.fzf}/bin/fzf";
      fd = "${pkgs.fd}/bin/fd";

      # Script to search for active sessions
      tmuxSessions =
        pkgs.writeShellScriptBin
        /*
        bash
        */
        "tmux-sessions" ''
          last_session=$(${tmux} display-message -p '#{client_last_session}')
          sessions=$(${tmux} list-sessions -F '#{session_name}' | grep -v "^$last_session$")

          if [[ -z $last_session ]]; then
              selected=$(echo "$sessions" | ${fzf} --tmux bottom --border-label=" Sessions ")
          else
              selected=$(echo -e "$last_session\n$sessions" | ${fzf} --tmux bottom --border-label=" Sessions ")
          fi

          if [[ -z $selected ]]; then
              exit 0
          fi

          selected_name=$(echo "$selected" | sed 's/:.*//')

          if ! ${tmux} has-session -t=$selected_name 2> /dev/null; then
              ${tmux} new-session -ds $selected_name -c $selected
          fi

          ${tmux} switch-client -t $selected_name
        '';

      # Script to create new sessions
      tmuxSessionizer =
        pkgs.writeShellScriptBin
        /*
        bash
        */
        "tmux-sessionizer" ''
          if [[ $# -eq 1 ]]; then
              selected=$1
          else
              selected=$(${fd} . --type d --max-depth 1 --full-path ${searchPaths} | ${fzf} --tmux=bottom --border-label=" Sessionizer ")
          fi

          if [[ -z $selected ]]; then
              exit 0
          fi

          selected_name=$(basename "$selected" | tr . _)
          tmux_running=$(pgrep tmux)

          if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
              ${tmux} new-session -s $selected_name -c $selected
              exit 0
          fi

          if ! ${tmux} has-session -t=$selected_name 2> /dev/null; then
              ${tmux} new-session -ds $selected_name -c $selected
          fi

          ${tmux} switch-client -t $selected_name
        '';
    in ''
      # Set true color
      set -ga terminal-overrides ",xterm-256color*:Tc"

      # Remap ctrl+b to ctrl+a
      unbind C-b
      set-option -g prefix C-a
      bind-key C-a send-prefix

      set -sg escape-time 0

      # Renumber all windows after one is closed
      set -g renumber-windows on

      # Settings for vi visual mode
      set-window-option -g mode-keys vi
      bind -T copy-mode-vi v send-keys -X begin-selection

      # Copy to clipboard
      bind -T copy-mode-vi y send-keys -X copy-pipe 'xclip -in -selection clipboard'
      bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe

      # Set visual mode text highlighting colors
      set-option -g mode-style 'bg=#4c4c4c'

      # Vim-like pane switching
      bind k select-pane -U
      bind j select-pane -D
      bind h select-pane -L
      bind l select-pane -R

      # Resize panes
      bind Up resize-pane -U 2
      bind Down resize-pane -D 2
      bind Left resize-pane -L 2
      bind Right resize-pane -R 2

      # Switch between tmux windows with <tab>
      bind-key Tab next-window

      # Mousemode
      set -g mouse on

      # Set status bar
      set-option -g status-position bottom
      set-option -g status-style 'bg=#0f1117,fg=white'

      # Set session
      set-option -g status-left-length 50
      set-option -g status-left '#[fg=#17171b,bg=#818596,bold] #S #[fg=#17171b,bg=#0f1117,bold]'

      # Set windows
      set-option -g status-justify left
      set-option -g window-status-format '#[fg=#c6c8d1,bg=#0f1117] #I #W '
      set-option -g window-status-current-format '#[fg=#c6c8d1,bg=#2e313f] #I #W '

      # Status bar right
      set-option -g status-right ""

      # Pane borders
      set -g pane-border-style 'fg=colour8'
      set -g pane-active-border-style 'fg=green'

      # Session management with custom scripts
      bind-key -r f run-shell "${lib.getExe tmuxSessionizer}"
      bind-key -r w run-shell "${lib.getExe tmuxSessions}"
    '';
  };
}

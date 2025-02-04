{
  programs.tmux = {
    enable = true;
    extraConfig = ''
      # Set true color
      set -g default-terminal "screen-256color"
      set -ga terminal-overrides ",xterm-256color*:Tc"

      # Reload tmux config
      bind-key R source-file ~/.tmux.conf \; display-message "Config reloaded..."

      # Remap ctrl+b to ctrl+a
      unbind C-b
      set-option -g prefix C-a
      bind-key C-a send-prefix

      # Increase scrollback buffer
      set-option -g history-limit 5000

      # Set window start index to 1
      set -g base-index 1

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

      # Status bar left
      set-option -g status-left-length 40
      set-option -g status-left '#[fg=#17171b,bg=#818596,bold] #S #[fg=#17171b,bg=#0f1117,bold]'

      # Status bar center
      set-option -g status-justify left
      set-option -g window-status-format '#[fg=#c6c8d1,bg=#0f1117] #I #W '
      set-option -g window-status-current-format '#[fg=#c6c8d1,bg=#2e313f] #I #W '

      # Status bar right
      set-option -g status-right ""

      # Pane borders
      set -g pane-border-style 'fg=colour8'
      set -g pane-active-border-style 'fg=green'

      #TODO: Create session scripts
      # Session management with custom scripts
      # bind-key -r f run-shell "~/.local/bin/tmux-sessionizer"
      # bind-key -r w run-shell "~/.local/bin/tmux-sessions"
    '';
  };
}

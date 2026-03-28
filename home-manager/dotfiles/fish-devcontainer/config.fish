if status is-interactive
    # Aliases
    alias lla 'ls -la'
    alias la 'ls -la'
    alias vimdiff 'nvim -d'
    alias vim="nvim"
    alias vi="nvim"

    # Interactive shell initialisation
    fzf --fish | source

    # Direnv integration
    direnv hook fish | source
end

# Global variables
set -gx EDITOR nvim
set -gx VISUAL nvim

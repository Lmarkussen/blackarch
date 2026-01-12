#source /usr/share/cachyos-fish-config/cachyos-config.fish

# Optional: overwrite greeting (currently commented out)
# function fish_greeting
#     # customize your greeting here, e.g. disable fastfetch
# end

function fish_prompt
    # interactive username@hostname with path, colored
    echo [ (set_color blue)(whoami)@(hostname)(set_color normal) ](set_color green) ">>" (set_color normal)"[" (set_color brblue)(pwd) (set_color normal) "]"
    echo (set_color cyan)"  >> "
end

# Start tmux only if not already inside tmux to avoid nested sessions warning
if not set -q TMUX
    tmux
end

# Aliases
alias ping="grc ping"
alias nmap="grc nmap"

# Created by `pipx` on 2025-11-25 11:48:15
set PATH $PATH /home/lars/.local/bin

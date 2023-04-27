alias reload="source ~/.zshrc"
alias python='python3'
alias pip='pip3'
alias lg='lazygit'
alias cat='bat --paging=never'
alias words="cat /usr/share/dict/words | fzf-tmux -l 20% --multi --reverse"
alias agg="agg --font-family 'MesloLGL Nerd Font Mono' --font-size 16 --idle-time-limit 1 --speed 1.3"
alias pn=pnpm
alias luarocks="luarocks --lua-dir=$(brew --prefix)/opt/lua@5.1 --lua-version=5.1"
alias jupyter-lab-deamon="jupyter-lab --no-browser --NotebookApp.allow_origin='*'."

# exa
alias l='exa'
alias la='exa -a'
alias ll='exa -lah'
alias ls='exa --color=auto'


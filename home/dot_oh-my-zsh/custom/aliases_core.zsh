alias reload="source ~/.zshrc"
alias cat='bat --paging=never'
alias words="cat /usr/share/dict/words | fzf-tmux -l 20% --multi --reverse"
alias agg="agg --font-family 'MesloLGL Nerd Font Mono' --font-size 16 --idle-time-limit 1 --speed 1.3"
alias lg='lazygit'

# eza
alias l='eza'
alias la='eza -a'
alias ll='eza -lah'
alias ls='eza --color=auto'

# cd
fzf_dir () {
  cd $1/$(ls $1 | fzf)  
}

alias mp="fzf_dir ~/personal/code/projects" 
alias mw="fzf_dir ~/work" 
alias ml="fzf_dir ~/personal/code/learning"
alias mi="cd ~/personal" 

# edit
alias es="nvim ~/.oh-my-zsh/custom/secrets.zsh"
alias el="nvim ~/.oh-my-zsh/custom/local.zsh"

# cat
alias cl="cat ~/.oh-my-zsh/custom/local.zsh"

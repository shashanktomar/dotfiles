fzf_dir () {
  cd $1/$(ls $1 | fzf)  
}

alias mp="fzf_dir ~/projects/personal" 
alias mw="fzf_dir ~/projects/work" 
alias ml="fzf_dir ~/projects/learning" 
alias mf="fzf_dir ~/projects/forks" 
alias mj="cd ~/projects/junkyard" 
alias mi="cd ~/personal" 

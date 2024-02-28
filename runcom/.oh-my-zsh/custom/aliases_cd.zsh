fzf_dir () {
  cd $1/$(ls $1 | fzf)  
}

alias mp="fzf_dir ~/personal/code/projects" 
alias mw="fzf_dir ~/work" 
alias ml="fzf_dir ~/personal/code/learning"
alias mi="cd ~/personal" 

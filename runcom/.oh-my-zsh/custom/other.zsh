# zsh related settings
bindkey "^[s" autosuggest-toggle # use ALT-s to toggle suggestions

# tmuxp related settings
export DISABLE_AUTO_TITLE='true'

# pnpm tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true

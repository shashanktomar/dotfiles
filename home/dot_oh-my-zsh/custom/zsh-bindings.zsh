bindkey "^[s" autosuggest-toggle # use ALT-s to toggle suggestions

############## ZSH VIM Mode Keybindings ###########
bindkey -v # Enable vim bindings

ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BEAM
ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
ZVM_OPPEND_MODE_CURSOR=$ZVM_CURSOR_UNDERLINE

ZVM_VI_INSERT_ESCAPE_BINDKEY=jj

############## ZSH Autocomplete plugin keybindings ###########
# bindkey '^I' menu-select
# bindkey "$terminfo[kcbt]" reverse-menu-select

bindkey -M menuselect              '^I'         menu-complete
bindkey -M menuselect "$terminfo[kcbt]" reverse-menu-complete

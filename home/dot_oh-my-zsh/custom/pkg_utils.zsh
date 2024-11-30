export PATH=$PATH:~/.docker/bin

########## Home Assistant ##########
export HASS_SERVER=http://home-assistant.local:8123
# Dont forget to export HASS_TOKEN=<secret>

source <(_HASS_CLI_COMPLETE=zsh_source hass-cli)

alias hac="hass-cli"
alias ssh-ha="ssh ha@192.168.4.29"

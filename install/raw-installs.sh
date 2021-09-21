#!/bin/sh

# Oh My Zsh
ZSH_PATH=${ZSH:-~/.oh-my-zsh}
if [[ ! -d $ZSH_PATH ]]; then
    # install oh-my-zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    # install spaceship prompt
    git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_PATH/themes/spaceship-prompt" --depth=1
    ln -s "$ZSH_PATH/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_PATH/themes/spaceship.zsh-theme"
    # install zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_PATH/custom/plugins/zsh-autosuggestions
    # install zsh-autocomplete
    git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_PATH/custom/plugins/zsh-autocomplete
else
    echo "$ZSH_PATH already exist. Not installing Oh-My-Zsh"
fi
#!/bin/sh

# Oh My Zsh
ZSH_PATH=${ZSH:-~/.oh-my-zsh}
if [[ ! -d $ZSH_PATH ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_PATH/themes/spaceship-prompt" --depth=1
    ln -s "$ZSH_PATH/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_PATH/themes/spaceship.zsh-theme"
else
    echo "$ZSH_PATH already exist. Not installing Oh-My-Zsh"
fi
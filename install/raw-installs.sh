#!/bin/sh

# Oh My Zsh
ZSH_PATH=${ZSH:-~/.oh-my-zsh}
ZSH_THEME_PATH=$ZSH_PATH/custom/themes
ZSH_PLUGIN_PATH=$ZSH_PATH/custom/plugins
if [[ ! -d $ZSH_PATH ]]; then
    # install oh-my-zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    # install powerlevel10k theme
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_THEME_PATH/powerlevel10k
    # install zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_PLUGIN_PATH/zsh-autosuggestions
    # install zsh-nvm plugin
    git clone https://github.com/lukechilds/zsh-nvm $ZSH_PLUGIN_PATH/zsh-nvm
else
    echo "$ZSH_PATH already exist. Not installing Oh-My-Zsh"
fi

# Install vim-plug
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
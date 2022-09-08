#!/bin/sh

# Oh My Zsh
ZSH_PATH=${ZSH:-~/.oh-my-zsh}
ZSH_THEME_PATH=$ZSH_CUSTOM/themes
ZSH_PLUGIN_PATH=$ZSH_CUSTOM/plugins
if [[ ! -d $ZSH_PATH ]]; then
  # install oh-my-zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  # install powerlevel10k theme
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_THEME_PATH/powerlevel10k"
  # install zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_PLUGIN_PATH/zsh-autosuggestions"
  # install zsh-nvm plugin
  git clone https://github.com/lukechilds/zsh-nvm "$ZSH_PLUGIN_PATH/zsh-nvm"
  # install zsh-vi-mode plugin
  git clone https://github.com/jeffreytse/zsh-vi-mode "$ZSH_PLUGIN_PATH/zsh-vi-mode"
else
    echo "$ZSH_PATH already exist. Not installing Oh-My-Zsh"
fi

# NvChad for nvim
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1

# Tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install dockutil. Brew does not have the latest version
DLURL=$(curl --silent "https://api.github.com/repos/kcrawford/dockutil/releases/latest" | jq -r .assets[].browser_download_url | grep pkg)
curl -sL ${DLURL} -o /tmp/dockutil.pkg
sudo installer -pkg "/tmp/dockutil.pkg" -target /

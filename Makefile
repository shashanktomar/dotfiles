SHELL = /bin/bash
DOTFILES_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
OS := $(shell bin/is-supported bin/is-macos macos linux)
PATH := $(DOTFILES_DIR)/bin:$(PATH)
NVM_DIR := $(HOME)/.nvm
export XDG_CONFIG_HOME = $(HOME)/.config
export STOW_DIR = $(DOTFILES_DIR)
export ACCEPT_EULA=Y

##@ General

# The help target prints out all targets with their descriptions organized
# beneath their categories. The categories are represented by '##@' and the
# target descriptions by '##'. The awk commands is responsible for reading the
# entire set of makefiles included in this invocation, looking for lines of the
# file as xyz: ## something, and then pretty-format the target and help. Then,
# if there's a line with ##@ something, that gets pretty-printed as a category.
# More info on the usage of ANSI control characters for terminal formatting:
# https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_parameters
# More info on the awk command:
# http://linuxcommand.org/lc3_adv_awk.php

help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Primary Targets

all: $(OS) ## You want to run this if you are setting up everything from scratch. It just call macos for now.

macos: sudo core-macos installs link mac-defaults ## Setup a new fresh machine. The target is idempotent.

##@ Installation

core-macos: brew npm ruby ## Install core packages for macos: brew, npm and ruby

installs: brew-packages cask-apps node-packages raw-installs post-installs ## Install brew, cask and node apps. Also install some raw package using bash script.

brew-packages: brew ## Install brew packages from /install/brewfile
	brew bundle --file=$(DOTFILES_DIR)/install/brewfile

cask-apps: brew ## Install brew cask packages from /install/caskfile
	brew bundle --file=$(DOTFILES_DIR)/install/Caskfile || true
	defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"
	for EXT in $$(cat install/vscodefile); do code --install-extension $$EXT; done
	# xattr -d -r com.apple.quarantine ~/Library/QuickLook

node-packages: npm ## Install npm packages from /install/npmfile
	. $(NVM_DIR)/nvm.sh; npm install -g $(shell cat install/npmfile)

raw-installs: ## Install raw packages using /install/raw-install.sh
	$(DOTFILES_DIR)/install/raw-installs.sh

post-installs: ## Run post-install script: /install/post-install.sh
	$(DOTFILES_DIR)/install/post-install.sh

##@ Setup Scripts and zsh

link: ## Create symlinks for zsh files and some other programs
	for FILE in $$(\ls -A runcom); do if [ -f $(HOME)/$$FILE -a ! -h $(HOME)/$$FILE ]; then \
		mv -v $(HOME)/$$FILE{,.bak}; fi; done
	mkdir -p $(XDG_CONFIG_HOME)
	stow -t $(HOME) runcom
	stow -t $(XDG_CONFIG_HOME) config

unlink: ## Delete symlinks for zsh files and some other programs
	stow --delete -t $(HOME) runcom
	stow --delete -t $(XDG_CONFIG_HOME) config
	for FILE in $$(\ls -A runcom); do if [ -f $(HOME)/$$FILE.bak ]; then \
		mv -v $(HOME)/$$FILE.bak $(HOME)/$${FILE%%.bak}; fi; done

##@ Setup Mac Settings

mac-defaults: ## Setup mac based on scripts under /macos
	$(DOTFILES_DIR)/macos/setup.sh

sudo:
ifndef GITHUB_ACTION
	sudo -v
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
endif

brew:
	is-executable brew || curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash

npm:
	if ! [ -d $(NVM_DIR)/.git ]; then git clone https://github.com/creationix/nvm.git $(NVM_DIR); fi
	. $(NVM_DIR)/nvm.sh; nvm install --lts

ruby: brew
	brew install ruby


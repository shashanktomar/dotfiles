# Just examples are here: https://github.com/casey/just/tree/master/examples
# Just docs are here: https://just.systems/man/en/introduction.html

# List all recipes
default:
    @just --list

###############################################
############## Build Commands #################
###############################################

# Install dotfiles
[group('build')]
install:
    ./install.sh

###############################################
############### Utilities #####################
###############################################

# Display config
[group('utilities')]
config:
    chezmoi cat-config | bat -l toml

# Render the packages script
[group('utilities')]
render-packages:
    bat home/.chezmoiscripts/darwin/run_onchange_before_03-install-packages.sh.tmpl | chezmoi execute-template | bat

# Render .chezmoiexternal
[group('utilities')]
render-external:
    bat home/.chezmoiexternal.toml.tmpl | chezmoi execute-template | bat -l toml

# Render the vscode extensions script
[group('utilities')]
render-vscode-ext:
    bat home/.chezmoiscripts/run_onchange_after_02-configure-vscode.sh.tmpl | chezmoi execute-template | bat

# Render .gitconfig
[group('utilities')]
render-git-config:
    bat home/dot_gitconfig.tmpl | chezmoi execute-template | bat

# Render ssh configs
[group('utilities')]
render-ssh-configs:
    bat home/private_dot_ssh/authorized_keys.tmpl | chezmoi execute-template | bat

# Render health-check
[group('utilities')]
render-health-check:
    bat home/.chezmoiscripts/run_after_11-health-check.sh.tmpl | chezmoi execute-template | bat

###############################################
############### Testing #######################
###############################################

# Run tests for Claude Code hooks
[group('test')]
test:
    cd home/private_dot_config/claude/hooks && uv run test_pre_tool_use.py -v
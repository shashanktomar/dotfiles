# zoxide
eval "$(zoxide init zsh)"

# mise
eval "$(mise activate zsh)"

# tmux
export DISABLE_AUTO_TITLE='true'

# 1password cli
export OP_BIOMETRIC_UNLOCK_ENABLED=true

# claude code
export CLAUDE_CONFIG_DIR=~/.config/claude

# Required for shell integration in vscode to work properly
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

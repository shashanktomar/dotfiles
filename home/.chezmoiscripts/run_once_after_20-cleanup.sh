#!/bin/bash

set -eufo pipefail

# Remove chezmoi from ~/.local/bin/ installed by ./install.sh script as we install is using package manager
if [ -f "$HOME/.local/bin/chezmoi" ]; then
  echo "🧹 Cleanup"
  echo "Deleting chezmoi installed by ./install.sh as it is also installed by package manager"
  rm -f "$HOME/.local/bin/chezmoi"
fi

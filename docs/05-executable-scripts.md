# Executable Scripts

This document explains how executable scripts in this dotfiles repository are made available system-wide.

## Script Location

Executable utility scripts are stored in `/bin/` directory at the root of the dotfiles repository.

## PATH Configuration

These scripts are made available through two PATH exports:

### 1. User bin directory (in `home/dot_zshrc:14`)
```bash
export PATH=$HOME/bin:/usr/local/bin:/opt/homebrew/bin:$PATH
```
This adds `$HOME/bin` to the PATH, though this directory may not exist by default.

### 2. Dotfiles bin directory (in `home/dot_oh-my-zsh/custom/bash_utils.zsh.tmpl`)
```bash
export PATH={{- .chezmoi.workingTree -}}/bin:${PATH}
```
This template adds the chezmoi working tree's `/bin` directory directly to PATH. The `.chezmoi.workingTree` variable resolves to the dotfiles repository location (e.g., `/Users/stomar/.dotfiles`).

## How It Works

When you type a command like `print-status`, the shell searches through the PATH directories in order. Since `{{.chezmoi.workingTree}}/bin` is added to PATH, the scripts in `/Users/stomar/.dotfiles/bin/` are directly accessible without needing to be copied or symlinked to another location.

This approach keeps the scripts in the repository while making them globally available for use in any terminal session.
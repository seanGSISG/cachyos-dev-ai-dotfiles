#!/bin/zsh
# Project-specific aliases for CachyOS development environment
# Source this file from your .zshrc

# Development shortcuts
alias devdir='cd ~/dev'
alias dotfiles='cd ~/dev/cachyos-dev-ai-dotfiles'

# Dotfiles management
alias sync-push='~/dev/cachyos-dev-ai-dotfiles/sync.sh push'
alias sync-pull='~/dev/cachyos-dev-ai-dotfiles/sync.sh pull'
alias sync-status='~/dev/cachyos-dev-ai-dotfiles/sync.sh status'

# Claude Code shortcuts
alias c='claude'
alias ccd='claude --dangerously-skip-permissions'

# Git shortcuts for dotfiles repo
alias dotgit='git -C ~/dev/cachyos-dev-ai-dotfiles'
alias dotst='dotgit status'
alias dotdiff='dotgit diff'
alias dotlog='dotgit log --oneline --graph --decorate'

# Quick edits
alias zshrc='$EDITOR ~/.zshrc'
alias aliases='$EDITOR ~/dev/cachyos-dev-ai-dotfiles/dotfiles/zsh/aliases.sh'
alias vimrc='$EDITOR ~/.vimrc'

# System monitoring
alias cpu='watch -n 1 "grep MHz /proc/cpuinfo"'
alias temp='watch -n 1 sensors'
alias ports='ss -tuln'

# Network
alias myip='curl -s ifconfig.me'
alias localip='ip addr show | grep "inet " | grep -v 127.0.0.1'

# Add your custom aliases below
# ...

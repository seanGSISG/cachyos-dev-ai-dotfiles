# Enhanced .zshrc for CachyOS Development Environment
# Inspired by Eric Buess's configuration

# Enable Powerlevel10k instant prompt (if using)
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY

# Directory navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# Completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Key bindings
bindkey -e  # Emacs mode
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# ============================================================================
# ALIASES
# ============================================================================

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'

# ls with colors and better defaults
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Git aliases - Basic
alias gs='git status'
alias gd='git diff'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias ga='git add'
alias gco='git checkout'

# Git aliases - Extended workflow
alias gaa='git add --all'
alias gcm='git commit -m'
alias gcam='git commit -am'
alias gca='git commit --amend'
alias gpl='git pull'
alias gf='git fetch'
alias gfa='git fetch --all'
alias grb='git rebase'
alias grbi='git rebase -i'
alias gm='git merge'
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gcl='git clone'
alias gst='git stash'
alias gstp='git stash pop'
alias gstl='git stash list'
alias gsta='git stash apply'
alias gr='git remote'
alias grv='git remote -v'
alias gra='git remote add'
alias greset='git reset'
alias gclean='git clean -fd'
alias gundo='git reset --soft HEAD~1'

# Git diff with delta (if installed)
if command -v delta &>/dev/null; then
    alias d='git diff | delta'
fi

# Grep with color
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Safety nets
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Tmux (universal)
alias ta='tmux attach -t'
alias tl='tmux list-sessions'
alias tn='tmux new-session -s'

# ============================================================================
# FUNCTIONS
# ============================================================================

# Set terminal title
set_title() {
    echo -ne "\033]0;$1\007"
}

# Create and enter directory
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract various archive types
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# UV Python virtual environment helper (from Eric's config)
# Usage: v script.py [args] - runs Python script in uv venv
# Usage: v - enters interactive Python in uv venv
# Usage: v pip install package - installs package in uv venv
v() {
    # Default to latest stable Python
    local PYTHON_VERSION="${UV_PYTHON_VERSION:-3.13}"

    # Check if .venv exists in current directory
    if [ ! -d ".venv" ]; then
        echo "Creating virtual environment with Python $PYTHON_VERSION..."
        uv venv --python "$PYTHON_VERSION"
    fi

    # If no arguments, start interactive Python
    if [ $# -eq 0 ]; then
        echo "Starting interactive Python in venv..."
        uv run python
    # If first arg is "pip", handle pip commands
    elif [ "$1" = "pip" ]; then
        shift
        uv pip "$@"
    # If first arg ends with .py, run the script
    elif [[ "$1" == *.py ]]; then
        uv run python "$@"
    # Otherwise, run the command in the venv
    else
        uv run "$@"
    fi
}

# Quick Python REPL alias
alias vpy='v'

# ============================================================================
# ENVIRONMENT VARIABLES
# ============================================================================

# Default editor (micro - modern, mouse-friendly terminal editor)
export EDITOR=micro
export VISUAL=micro

# Add local bin to PATH if it exists
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"

# Python UV configuration
export UV_PYTHON_VERSION=3.13

# Ripgrep configuration file
export RIPGREP_CONFIG_PATH="$HOME/.rgrc"

# Bat as MANPAGER (colored man pages!)
if command -v bat &>/dev/null; then
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
    export MANROFFOPT="-c"
fi

# FZF configuration
if command -v fzf &>/dev/null; then
    # Use fd instead of find for fzf (respects .gitignore)
    if command -v fd &>/dev/null; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    fi

    # FZF color scheme (Catppuccin Mocha)
    export FZF_DEFAULT_OPTS="
        --height 40%
        --layout=reverse
        --border
        --inline-info
        --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
        --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
        --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
    "
fi

# Eza colors (if using eza)
if command -v eza &>/dev/null; then
    export EZA_COLORS="da=36:gm=33"
fi

# Rust cargo bin
[[ -d "$HOME/.cargo/bin" ]] && export PATH="$HOME/.cargo/bin:$PATH"

# Node Version Manager (if using nvm)
if [[ -d "$HOME/.nvm" ]]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

# ============================================================================
# PLUGINS & THEMES
# ============================================================================

# Starship prompt (if installed)
if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
fi

# Zoxide (better cd) - if installed
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
    alias cd='z'
fi

# FZF (fuzzy finder) - if installed
if command -v fzf &>/dev/null; then
    source <(fzf --zsh)
fi

# Mise (runtime version manager) - if installed
if command -v mise &>/dev/null; then
    eval "$(mise activate zsh)"
fi

# ============================================================================
# PROJECT-SPECIFIC CONFIGURATIONS
# ============================================================================

# Source project-specific dotfiles if they exist
[[ -f ~/dev/cachyos-dev-ai-dotfiles/dotfiles/zsh/aliases.sh ]] && \
    source ~/dev/cachyos-dev-ai-dotfiles/dotfiles/zsh/aliases.sh

# Source helper functions
[[ -f ~/dev/cachyos-dev-ai-dotfiles/dotfiles/zsh/helpers.sh ]] && \
    source ~/dev/cachyos-dev-ai-dotfiles/dotfiles/zsh/helpers.sh

# ============================================================================
# WELCOME MESSAGE
# ============================================================================

# Display system info on new terminal (optional)
# if command -v fastfetch &>/dev/null; then
#     fastfetch
# fi

# ============================================================================
# END OF .zshrc
# ============================================================================

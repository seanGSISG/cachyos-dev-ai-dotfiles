#!/bin/zsh
# Project-specific aliases for CachyOS development environment
# Source this file from your .zshrc

# ============================================================================
# CACHYOS/ARCH SPECIFIC
# ============================================================================

# System management
alias update='sudo pacman -Syu'
alias install='sudo pacman -S'
alias search='pacman -Ss'
alias remove='sudo pacman -Rns'

# AUR helper
if command -v paru &>/dev/null; then
    alias aur='paru'
elif command -v yay &>/dev/null; then
    alias aur='yay'
fi

# ============================================================================
# DOTFILES REPO SHORTCUTS
# ============================================================================

# Navigation
alias devdir='cd ~/dev'
alias dotfiles='cd ~/dev/cachyos-dev-ai-dotfiles'

# Dotfiles sync
alias sync-push='~/dev/cachyos-dev-ai-dotfiles/sync.sh push'
alias sync-pull='~/dev/cachyos-dev-ai-dotfiles/sync.sh pull'
alias sync-status='~/dev/cachyos-dev-ai-dotfiles/sync.sh status'

# Git shortcuts for dotfiles repo
alias dotgit='git -C ~/dev/cachyos-dev-ai-dotfiles'
alias dotst='dotgit status'
alias dotdiff='dotgit diff'
alias dotlog='dotgit log --oneline --graph --decorate'

# ============================================================================
# CLAUDE CODE SHORTCUTS
# ============================================================================

alias c='claude'
alias cc='claude'
alias claude='claude'
alias ccd='claude --dangerously-skip-permissions'
alias ccinit='~/dev/cachyos-dev-ai-dotfiles/scripts/init-claude-project.sh'
alias claude-init='ccinit'

# ============================================================================
# SYSTEM MONITORING
# ============================================================================

# Individual monitors
alias cpu='watch -n 1 "grep MHz /proc/cpuinfo"'
alias temp='watch -n 1 sensors'
alias ports='ss -tuln'

# Combined monitoring (btop + nvtop side-by-side)
alias sysmon='tmux new-session -s sysmon \; split-window -h \; send-keys "btop" Enter \; select-pane -L \; send-keys "nvtop" Enter'
alias sysmon-kill='tmux kill-session -t sysmon'

# ============================================================================
# QUICK EDITS
# ============================================================================

alias zshrc='$EDITOR ~/.zshrc'
alias aliases='$EDITOR ~/dev/cachyos-dev-ai-dotfiles/dotfiles/zsh/aliases.sh'
alias vimrc='$EDITOR ~/.vimrc'

# ============================================================================
# EDITOR - MICRO
# ============================================================================

# Micro editor shortcuts (modern, mouse-friendly)
if command -v micro &>/dev/null; then
    alias edit='micro'
    alias e='micro'
    alias m='micro'

    # Redirect vim to micro (vim still available as /usr/bin/vim)
    alias vim='micro'

    # Keep original vim accessible if needed
    alias ovim='/usr/bin/vim'
fi

# ============================================================================
# MODERN CLI TOOLS - BAT, EZA, FD
# ============================================================================

# Bat (better cat with syntax highlighting)
if command -v bat &>/dev/null; then
    alias cat='bat'                          # Replace cat with bat
    alias bcat='/usr/bin/cat'                # Original cat if needed
    alias b='bat'                            # Short alias
    alias bp='bat --paging=always'           # Force paging
    alias bn='bat --style=plain'             # Plain output (no line numbers)
fi

# Eza (better ls with colors, icons, git status)
if command -v eza &>/dev/null; then
    # Basic replacements
    alias ls='eza --group-directories-first' # Directories first
    alias ll='eza -lah --git --group-directories-first'  # Long format with git status
    alias la='eza -a --group-directories-first'          # Show hidden
    alias l='eza -1 --group-directories-first'           # One per line

    # Tree views
    alias lt='eza --tree --level=2 --group-directories-first'  # Tree view (2 levels)
    alias lt3='eza --tree --level=3 --group-directories-first' # Tree view (3 levels)
    alias lta='eza --tree --level=2 -a --group-directories-first' # Tree with hidden

    # Git integration
    alias lg='eza -lah --git --git-ignore --group-directories-first'  # Show git status
    alias lgi='eza -lah --git --group-directories-first'             # Git status (ignored files too)

    # Sorting
    alias lm='eza -lah --sort=modified --group-directories-first'    # Sort by modified time
    alias ls='eza -lah --sort=size --group-directories-first'        # Sort by size (override lS later)
    alias lS='eza -lah --sort=size --group-directories-first'        # Explicit size sort

    # Keep original ls if needed
    alias ols='/usr/bin/ls --color=auto'
fi

# Fd (better find)
if command -v fd &>/dev/null; then
    alias find='fd'                          # Replace find with fd
    alias ofind='/usr/bin/find'              # Original find if needed

    # Fd shortcuts
    alias fda='fd --hidden --no-ignore'      # Find all (including hidden/ignored)
    alias fdd='fd --type d'                  # Find directories only
    alias fdf='fd --type f'                  # Find files only
    alias fdx='fd --type x'                  # Find executables only
    alias fde='fd --extension'               # Find by extension (usage: fde py)
fi

# ============================================================================
# SEARCH - RIPGREP
# ============================================================================

# Basic ripgrep aliases (rg is already the command)
alias rgi='rg --ignore-case'                    # Case-insensitive search
alias rgh='rg --hidden'                         # Include hidden files
alias rgf='rg --files'                          # List all files (respects .gitignore)
alias rgfa='rg --files --hidden --no-ignore'    # List ALL files (even ignored)

# Search specific file types
alias rgpy='rg --type=py'                       # Search only Python files
alias rgjs='rg --type=js'                       # Search only JavaScript files
alias rgrs='rg --type=rust'                     # Search only Rust files
alias rgmd='rg --type=markdown'                 # Search only Markdown files
alias rgsh='rg --type=script'                   # Search only shell scripts

# Search with context
alias rg1='rg -C 1'                             # 1 line before/after
alias rg3='rg -C 3'                             # 3 lines before/after
alias rg5='rg -C 5'                             # 5 lines before/after

# Advanced searches
alias rgw='rg --word-regexp'                    # Match whole words only
alias rgl='rg --files-with-matches'             # Only show filenames
alias rgL='rg --files-without-match'            # Files that DON'T match
alias rgc='rg --count'                          # Count matches per file

# Search and replace preview (dry-run)
rgreplace() {
    if [ $# -lt 2 ]; then
        echo "Usage: rgreplace 'old_pattern' 'new_pattern' [files]"
        echo "Example: rgreplace 'foo' 'bar' '*.py'"
        return 1
    fi
    echo "Preview of changes (not actually replacing):"
    rg "$1" -l | xargs -I {} sh -c "echo '--- {} ---' && grep -n '$1' {}"
    echo ""
    echo "To actually replace, use: rg '$1' -l | xargs sed -i 's/$1/$2/g'"
}

# ============================================================================
# NETWORK
# ============================================================================

alias myip='curl -s ifconfig.me'
alias localip='ip addr show | grep "inet " | grep -v 127.0.0.1'

# ============================================================================
# DOCKER & CONTAINERS
# ============================================================================

if command -v docker &>/dev/null; then
    # Docker basics
    alias d='docker'
    alias dps='docker ps'
    alias dpsa='docker ps -a'
    alias di='docker images'
    alias dimg='docker images'
    alias dv='docker volume ls'
    alias dn='docker network ls'

    # Docker exec (interactive shell)
    alias dex='docker exec -it'
    alias dsh='docker exec -it'

    # Docker logs
    alias dlogs='docker logs'
    alias dlogsf='docker logs -f'
    alias dlogst='docker logs --tail 100 -f'

    # Docker run
    alias dr='docker run'
    alias drit='docker run -it --rm'

    # Docker compose
    alias dc='docker compose'
    alias dcu='docker compose up'
    alias dcud='docker compose up -d'
    alias dcd='docker compose down'
    alias dcl='docker compose logs -f'
    alias dcr='docker compose restart'
    alias dce='docker compose exec'

    # Docker cleanup
    alias dprune='docker system prune -af'
    alias dprune-volumes='docker system prune -af --volumes'
    alias dclean-containers='docker rm $(docker ps -aq) 2>/dev/null || echo "No containers to remove"'
    alias dclean-images='docker rmi $(docker images -q) 2>/dev/null || echo "No images to remove"'

    # Docker inspect helpers
    alias dins='docker inspect'
    alias dinsp='docker inspect --format="{{.NetworkSettings.IPAddress}}"'

    # Docker GPU
    alias dgpu='docker run --rm --gpus all'
fi

# Distrobox shortcuts
if command -v distrobox &>/dev/null; then
    alias db='distrobox'
    alias dbl='distrobox list'
    alias dbe='distrobox enter'
    alias dbc='distrobox create'
    alias dbr='distrobox rm'
    alias dbs='distrobox stop'
fi

# ============================================================================
# CUSTOM ALIASES (add your own below)
# ============================================================================

# Add your custom aliases below
# ...

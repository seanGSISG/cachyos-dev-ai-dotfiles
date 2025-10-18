#!/bin/bash

# CachyOS Dotfiles Sync Script
# Syncs dotfiles between home directory and repository

# Configuration mapping
# Format: "source_path:dest_path"
declare -a SYNC_CONFIGS=(
    # Shell configs
    ".zshrc:dotfiles/zsh/.zshrc"
    ".zprofile:dotfiles/zsh/.zprofile"
    ".zshenv:dotfiles/zsh/.zshenv"

    # Development tools
    ".tmux.conf:dotfiles/tmux/tmux.conf"
    ".vimrc:dotfiles/vim/vimrc"
    ".gitconfig:dotfiles/git/gitconfig"
    ".gitignore_global:dotfiles/git/gitignore_global"

    # Claude CLI
    ".claude/settings.json:dotfiles/claude/settings.json"
    ".claude/hooks:dotfiles/claude/hooks"

    # Neovim
    ".config/nvim:dotfiles/nvim"

    # SSH (config only, not keys!)
    ".ssh/config:dotfiles/ssh/config"

    # Starship prompt (if using)
    ".config/starship.toml:dotfiles/starship/starship.toml"

    # Add new configs here as needed
)

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
MODE=${1:-status}

echo "CachyOS Dotfiles Sync | Mode: $MODE | Repo: $REPO_DIR"

# Function to check for sensitive content
check_sensitive() {
    local file="$1"

    # Check filename patterns
    case "$(basename "$file")" in
        *.key|*.pem|*.p12|*.pfx|id_rsa*|id_ed25519*|id_dsa*|id_ecdsa*)
            echo "  ⚠️  SKIPPING (private key): $file"
            return 1
            ;;
        .env|.env.*|*.env)
            echo "  ⚠️  SKIPPING (env file): $file"
            return 1
            ;;
        *secret*|*token*|*password*|*credential*)
            echo "  ⚠️  SKIPPING (sensitive name): $file"
            return 1
            ;;
        *history|.bash_history|.zsh_history|.python_history|.node_repl_history)
            echo "  ⚠️  SKIPPING (history file): $file"
            return 1
            ;;
        .lesshst|.viminfo|.wget-hsts|.recently-used*)
            echo "  ⚠️  SKIPPING (usage tracking): $file"
            return 1
            ;;
        known_hosts|authorized_keys)
            echo "  ⚠️  SKIPPING (SSH keys/hosts): $file"
            return 1
            ;;
    esac

    # For text files, check content
    if [[ -f "$file" ]] && file "$file" | grep -q "text"; then
        if grep -qE "(PRIVATE KEY|BEGIN RSA|BEGIN DSA|BEGIN EC|BEGIN OPENSSH)" "$file" 2>/dev/null; then
            echo "  ⚠️  SKIPPING (contains private key): $file"
            return 1
        fi
        if grep -qE "^[A-Z_]+_(KEY|TOKEN|SECRET|PASSWORD|API|CREDENTIAL)=" "$file" 2>/dev/null; then
            echo "  ⚠️  WARNING (may contain secrets): $file"
            read -p "    Include this file anyway? (y/N) " -n 1 -r
            echo
            [[ ! $REPLY =~ ^[Yy]$ ]] && return 1
        fi
    fi

    return 0
}

# Function to safely copy files
safe_copy() {
    local src="$1"
    local dest="$2"

    if [[ -e "$src" ]]; then
        # Check for sensitive content first
        if ! check_sensitive "$src"; then
            return 1
        fi

        mkdir -p "$(dirname "$dest")"
        if [[ -d "$src" ]]; then
            echo "  📁 Copying directory: $src"
            # For directories, use rsync with exclude patterns
            rsync -a --delete \
                --exclude="*.key" \
                --exclude="*.pem" \
                --exclude="id_rsa*" \
                --exclude="id_ed25519*" \
                --exclude="id_ecdsa*" \
                --exclude="id_dsa*" \
                --exclude=".env" \
                --exclude=".env.*" \
                --exclude="*secret*" \
                --exclude="*token*" \
                --exclude="*history" \
                --exclude=".*_history" \
                --exclude=".viminfo" \
                --exclude=".lesshst" \
                --exclude="known_hosts" \
                --exclude="authorized_keys" \
                --exclude="*.log" \
                --exclude="*.cache" \
                --exclude="node_modules" \
                --exclude=".git" \
                "$src/" "$dest/"
        else
            echo "  📄 Copying file: $src"
            cp "$src" "$dest"
        fi
        return 0
    else
        echo "  ⏭️  Skipping (not found): $src"
        return 1
    fi
}

# Function to safely restore files
safe_restore() {
    local src="$1"
    local dest="$2"

    if [[ -e "$src" ]]; then
        mkdir -p "$(dirname "$dest")"
        if [[ -d "$src" ]]; then
            echo "  📁 Restoring directory: $dest"
            rsync -a "$src/" "$dest/"
        else
            echo "  📄 Restoring file: $dest"
            cp "$src" "$dest"
        fi
        return 0
    else
        echo "  ⏭️  Skipping (not in repo): $src"
        return 1
    fi
}

# Function to check differences
check_diff() {
    local src="$1"
    local dest="$2"

    if [[ ! -e "$src" ]]; then
        echo "  ✗ Missing in home: $src"
        return 1
    elif [[ ! -e "$dest" ]]; then
        echo "  + New file: $src"
        return 0
    elif [[ -d "$src" ]] && [[ -d "$dest" ]]; then
        # For directories, just note they exist
        echo "  📁 Directory: $src"
        return 0
    elif diff -q "$src" "$dest" > /dev/null 2>&1; then
        echo "  ✓ In sync: $src"
        return 0
    else
        echo "  ≠ Modified: $src"
        # Show brief diff
        if [[ -f "$src" ]] && [[ -f "$dest" ]]; then
            echo "    $(diff -u "$dest" "$src" | head -5 | tail -3)"
        fi
        return 0
    fi
}

case $MODE in
    push)
        echo "📤 Pushing configs from home to repository..."
        echo ""

        for config in "${SYNC_CONFIGS[@]}"; do
            IFS=':' read -r src dest <<< "$config"
            safe_copy "$HOME/$src" "$REPO_DIR/$dest"
        done

        echo -e "\n✅ Push complete! Review changes with: git status"
        ;;

    pull)
        echo "📥 Pulling configs from repository to home..."
        echo ""

        for config in "${SYNC_CONFIGS[@]}"; do
            IFS=':' read -r src dest <<< "$config"
            safe_restore "$REPO_DIR/$dest" "$HOME/$src"
        done

        echo -e "\n✅ Pull complete! Test with: source ~/.zshrc"
        ;;

    status|*)
        echo "📊 Checking sync status..."
        echo ""

        for config in "${SYNC_CONFIGS[@]}"; do
            IFS=':' read -r src dest <<< "$config"
            check_diff "$HOME/$src" "$REPO_DIR/$dest"
        done

        echo ""
        echo "Usage:"
        echo "  $0 status  - Check sync status (default)"
        echo "  $0 push    - Push configs from home to repo"
        echo "  $0 pull    - Pull configs from repo to home"
        echo ""
        echo "⚠️  Note: This is a reference repository for your environment."
        echo "Always review changes before committing!"
        echo ""
        echo "To add new configs, edit SYNC_CONFIGS array in this script"
        ;;
esac

#!/usr/bin/env bash
set -euo pipefail

# Quick script to apply dotfiles using stow
# This is a lightweight alternative to running the full bootstrap.sh

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "==> Applying dotfiles from $REPO_DIR"

# Check if stow is installed
if ! command -v stow >/dev/null 2>&1; then
  echo "Error: stow is not installed. Please install it first:"
  echo "  sudo pacman -S stow"
  exit 1
fi

# Backup conflicting files
echo "==> Checking for conflicts..."
BACKUP_DIR="${HOME}/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
backed_up=0

declare -a DOTFILES_TO_CHECK=(
  ".zshrc"
  ".gitconfig"
  ".config/starship.toml"
  ".config/kitty/kitty.conf"
)

for file in "${DOTFILES_TO_CHECK[@]}"; do
  filepath="${HOME}/${file}"
  if [ -e "$filepath" ] && [ ! -L "$filepath" ]; then
    # File exists and is not a symlink - back it up
    if [ $backed_up -eq 0 ]; then
      mkdir -p "$BACKUP_DIR"
      backed_up=1
    fi
    filedir="$(dirname "$file")"
    mkdir -p "${BACKUP_DIR}/${filedir}"
    cp -a "$filepath" "${BACKUP_DIR}/${file}"
    echo "  Backed up: ${file}"
    # Remove the file so stow can create symlink
    rm -f "$filepath"
  fi
done

if [ $backed_up -eq 1 ]; then
  echo "  ✓ Original dotfiles backed up to: ${BACKUP_DIR}"
fi

# Stow the dotfiles
echo "==> Stowing dotfiles..."
cd "$REPO_DIR/dotfiles"

for pkg in git zsh starship kitty konsolerc konsole-profile vscode claude; do
  if [ -d "$pkg" ]; then
    echo "  Stowing $pkg..."
    if stow -v -d . -t ~ "$pkg" 2>&1 | grep -v "BUG in find_stowed_path"; then
      echo "    ✓ $pkg stowed successfully"
    fi
  fi
done

# Verify critical dotfiles are symlinked
echo "==> Verifying symlinks..."
if [ -L ~/.zshrc ]; then
  echo "  ✓ ~/.zshrc is symlinked to $(readlink ~/.zshrc)"
else
  echo "  ⚠ ~/.zshrc is NOT a symlink"
fi

if [ -L ~/.gitconfig ]; then
  echo "  ✓ ~/.gitconfig is symlinked to $(readlink ~/.gitconfig)"
fi

# Create claude-code symlink if needed (installer creates 'claude' binary)
if [ -f "${HOME}/.local/bin/claude" ] && [ ! -f "${HOME}/.local/bin/claude-code" ]; then
  ln -sf "${HOME}/.local/bin/claude" "${HOME}/.local/bin/claude-code"
  echo "  ✓ Created claude-code symlink for compatibility"
fi

echo ""
echo "✅ Dotfiles applied successfully!"
echo ""
echo "Next steps:"
echo "  1. Reload your shell: source ~/.zshrc"
echo "  2. Or start a new terminal session"
echo "  3. Test Claude Code: c (or claude, or claude-code)"
echo ""
echo "To undo, restore from: ${BACKUP_DIR:-no backup was needed}"

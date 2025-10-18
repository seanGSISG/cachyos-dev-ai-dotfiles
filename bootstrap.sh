#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# CachyOS / Arch — KDE Plasma + NVIDIA + Dev/AI stack
#
# !! LOGIC !!
# 1. This script ONLY installs packages and creates the AI venv.
# 2. All shell configuration (hooks, aliases) is handled
#    by the .zshrc file managed by 'stow'.
#
# Optional toggles (set before running if you want):
#   ENABLE_VIRT=1         # install & enable libvirt/KVM stack
#   ENABLE_NEMO_DEFAULT=1 # set Nemo as default file manager
# ============================================================

ENABLE_VIRT="${ENABLE_VIRT:-0}"
ENABLE_NEMO_DEFAULT="${ENABLE_NEMO_DEFAULT:-0}"

need() { command -v "$1" >/dev/null 2_>/dev/null; }

echo "==> System update"
if ! need sudo; then echo "Need sudo"; exit 1; fi
sudo pacman -Syu --noconfirm

echo "==> Removing conflicting legacy NVIDIA driver"
# This ensures we don't conflict with nvidia-open-dkms
sudo pacman -Rdd --noconfirm nvidia-dkms || true

echo "==> Base packages (mise + uv workflow)"
sudo pacman -S --needed --noconfirm \
  git base-devel curl wget unzip zip stow \
  zsh starship tmux fzf zoxide fd ripgrep eza bat btop fastfetch direnv \
  jq yq aria2 git-delta \
  cmake ninja clang lld pkgconf \
  uv \
  mise \
  kitty github-cli \
  python \
  konsole dolphin ark kdeplasma-addons spectacle \
  xdg-desktop-portal-kde qt6-wayland egl-wayland \
  kvantum kvantum-qt5 \
  ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols papirus-icon-theme \
  nvidia-open-dkms nvidia-utils nvidia-settings opencl-nvidia cuda cudnn nccl nvtop \
  nvidia-container-toolkit \
  docker docker-buildx docker-compose \
  distrobox \
  nvme-cli lm_sensors vulkan-tools ffmpeg \
  zsh-autosuggestions zsh-syntax-highlighting \
  ufw zram-generator

# --- AUR helper (paru) if missing
if ! need paru; then
  echo "==> Installing AUR helper (paru-bin)"
  tmp="$(mktemp -d)"
  git -C "$tmp" clone https://aur.archlinux.org/paru-bin.git
  (cd "$tmp/paru-bin" && makepkg -si --noconfirm)
  rm -rf "$tmp"
fi

echo "==> AUR packages (themes)"
# Refresh AUR cache first
paru -Syy --noconfirm
# Install themes
paru -S --needed --noconfirm \
  catppuccin-plasma-colorscheme-mocha \
  kvantum-theme-catppuccin-git \
  catppuccin-cursors-mocha \
  bibata-cursor-theme-bin

echo "==> Configuring fonts"
# This enables Nerd Font symbols system-wide
sudo ln -sf /usr/share/fontconfig/conf.avail/10-nerd-font-symbols.conf /etc/fonts/conf.d/10-nerd-font-symbols.conf
sudo fc-cache -f -v

echo "==> Default shell (zsh)"
# Add zsh to /etc/shells if it's not there
if ! grep -q "/usr/bin/zsh" /etc/shells; then
  echo "/usr/bin/zsh" | sudo tee -a /etc/shells
fi
if [ "${SHELL:-}" != "$(command -v zsh)" ]; then
  # This command might fail non-fatally, which is OK.
  chsh -s "$(command -v zsh)" || true
fi

echo "==> Setting up 'mise' global toolchains"
# This installs and sets global default versions for core tools.
# Projects can override this with a local .tool-versions file.
if need mise; then
  # Use Python 3.13 since PyTorch 2.6+ supports it
  mise use -g python@3.13
  mise use -g node@lts
  mise use -g ruff@latest
  mise use -g black@latest
  mise use -g pre-commit@latest
  
  # === THIS IS THE FIX ===
  # Now, explicitly and synchronously install them.
  # This forces the script to WAIT until downloads/installs are complete.
  echo "==> Forcing synchronous install of mise toolchains (this may take a minute)..."
  mise install
  echo "==> Mise install complete."
else
  echo "WARNING: 'mise' not found, skipping toolchain setup."
fi

echo "==> Creating default AI venv with 'uv' and PyTorch"
# Create a dedicated venv for AI work with PyTorch compiled for CUDA
# Your system has CUDA 13.0, so we use cu130 wheels
if need uv; then
  echo "Creating venv at ${HOME}/venvs/ai-torch..."
  # Use system Python 3.13 which PyTorch 2.6+ supports
  uv venv "${HOME}/venvs/ai-torch" --python python3.13
  
  echo "Installing PyTorch (for CUDA 13.0), Jupyter, and linters..."
  # Updated to use CUDA 13.0 (cu130) which has Python 3.13 support
  # Use --extra-index-url to keep PyPI as primary source for non-PyTorch packages
  uv pip install --python "${HOME}/venvs/ai-torch/bin/python" \
    jupyterlab \
    torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu130 \
    ruff \
    black \
    pre-commit
else
  echo "WARNING: 'uv' not found, skipping AI venv setup."
fi

echo "==> VS Code Insiders extensions (incl. Claude)"
# This assumes your 'code-insiders' executable is on your PATH
# (We will add it in the .zshrc file)
if command -v code-insiders >/dev/null; then
  code-insiders --install-extension ms-python.python || true
  code-insiders --install-extension ms-python.vscode-pylance || true
  code-insiders --install-extension charliermarsh.ruff || true
  code-insiders --install-extension ms-azuretools.vscode-docker || true
  code-insiders --install-extension dbaeumer.vscode-eslint || true
  code-insiders --install-extension esbenp.prettier-vscode || true
  code-insiders --install-extension github.vscode-pull-request-github || true
  code-insiders --install-extension ms-vscode.makefile-tools || true
  code-insiders --install-extension anthropic.claude-dev || true
else
  echo "WARNING: 'code-insiders' command not found. Skipping extension install."
  echo "Please ensure /home/lsdmt/vscode-insiders/bin is on your PATH."
fi

echo "==> Docker + NVIDIA runtime"
sudo nvidia-ctk runtime configure --runtime=docker || true
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER" || true

echo "==> Ollama"
if ! pacman -Qs '^ollama$' >/dev/null; then
  if paru -Si ollama-bin >/dev/null 2>/dev/null; then
    paru -S --noconfirm ollama-bin
  else
    curl -fsSL https://ollama.com/install.sh | sh
  fi
fi
sudo systemctl enable --now ollama

echo "==> Enable periodic TRIM (NVMe)"
sudo systemctl enable --now fstrim.timer || true

echo "==> NVIDIA persistence (fewer CUDA cold-starts)"
sudo systemctl enable --now nvidia-persistenced || true

echo "==> Firewall (deny inbound, allow outbound)"
sudo ufw default deny incoming || true
sudo ufw default allow outgoing || true
sudo ufw --force enable || true

echo "==> Git delta defaults"
git config --global core.pager "delta"
git config --global interactive.diffFilter "delta --color-only"
git config --global delta.navigate true
git config --global delta.line-numbers true

echo "==> zram (48G, zstd for 96G RAM)"
# Use 50% of RAM (48G) for zram, which is more
# appropriate for 96G total RAM than the default.
if [ ! -f /etc/systemd/zram-generator.conf.d/99-custom.conf ]; then
  sudo mkdir -p /etc/systemd/zram-generator.conf.d
  sudo tee /etc/systemd/zram-generator.conf.d/99-custom.conf >/dev/null <<'EOT'
[zram0]
zram-size = 48G
compression-algorithm = zstd
EOT
  # Reload and apply - handle existing zram gracefully
  sudo systemctl daemon-reload
  # Stop existing zram if running
  sudo systemctl stop systemd-zram-setup@zram0.service 2>/dev/null || true
  # Reset zram device if it exists
  if [ -e /dev/zram0 ]; then
    sudo zramctl --reset /dev/zram0 2>/dev/null || true
  fi
  # Start with new config
  sudo systemctl start systemd-zram-setup@zram0.service || true
fi

if [ "$ENABLE_VIRT" = "1" ]; then
  echo "==> Virtualization stack (libvirt/KVM)"
  sudo pacman -S --needed --noconfirm qemu-full libvirt virt-manager edk2-ovmf swtpm
  sudo systemctl enable --now libvirtd || true
  sudo usermod -aG libvirt "$USER" || true
fi

if [ "$ENABLE_NEMO_DEFAULT" = "1" ]; then
  echo "==> Nemo file manager (Windows-like Details) & defaults"
  if paru -Si nemo >/dev/null 2>/dev/null; then
    paru -S --noconfirm nemo nemo-fileroller nemo-preview || true
    if [ -f /usr/share/applications/nemo.desktop ]; then
      xdg-mime default nemo.desktop inode/directory
      xdg-mime default nemo.desktop x-scheme-handler/trash
    fi
  fi
fi

echo "==> Backing up existing dotfiles and configuring with stow"
# Create backup directory with timestamp
BACKUP_DIR="${HOME}/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

# List of dotfiles to backup (these might conflict with stow)
DOTFILES_TO_BACKUP=(
  ".gitconfig"
  ".zshrc"
  ".config/konsolerc"
  ".config/kitty/kitty.conf"
  ".config/starship.toml"
  ".config/Code - Insiders/User/settings.json"
  ".local/share/konsole/Cachy.profile"
)

# Backup existing files if they exist and are not symlinks
backed_up=0
for file in "${DOTFILES_TO_BACKUP[@]}"; do
  filepath="${HOME}/${file}"
  if [ -e "$filepath" ] && [ ! -L "$filepath" ]; then
    # File exists and is not a symlink - back it up
    filedir="$(dirname "$file")"
    mkdir -p "${BACKUP_DIR}/${filedir}"
    cp -a "$filepath" "${BACKUP_DIR}/${file}"
    echo "  Backed up: ${file}"
    backed_up=1
    # Remove the file so stow can create symlink
    rm -f "$filepath"
  fi
done

if [ $backed_up -eq 1 ]; then
  echo "  ✓ Original dotfiles backed up to: ${BACKUP_DIR}"
else
  # No files were backed up, remove empty backup dir
  rmdir "$BACKUP_DIR" 2>/dev/null || true
  echo "  No conflicting dotfiles found - clean install"
fi

# Now stow the dotfiles (this assumes we're running from the repo root)
if [ -d "dotfiles" ]; then
  echo "  Stowing dotfiles..."
  cd dotfiles
  for pkg in git zsh starship kitty konsolerc konsole-profile vscode; do
    if [ -d "$pkg" ]; then
      stow -d . -t ~ "$pkg" 2>/dev/null && echo "    ✓ $pkg" || echo "    ⚠ $pkg (skipped)"
    fi
  done
  cd ..
else
  echo "  ⚠ 'dotfiles' directory not found - skipping stow"
  echo "    (This is expected if running bootstrap.sh outside the repo)"
fi


cat <<'MSG'

✅ Bootstrap complete.

Next steps:
1) Log out and log back in (or reboot) to apply group/shell changes.
2. Your shell is now configured via your .zshrc dotfile.
3. Your default AI venv is ready. To use it:
   - Activate: source ${HOME}/venvs/ai-torch/bin/activate
   - Test PyTorch: python -c "import torch; print(torch.cuda.is_available())"
4. In VS Code: Ctrl+Shift+P → “Claude: Sign in”.
MSG

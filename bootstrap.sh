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

echo "==> Base packages (mise + uv workflow)"
sudo pacman -S --needed --noconfirm \
  # core dev & QoL
  git base-devel curl wget unzip zip stow \
  zsh starship tmux fzf zoxide fd ripgrep eza bat btop fastfetch direnv \
  jq yq aria2 git-delta \
  cmake ninja clang lld pkgconf \
  # modern toolchains
  uv \
  # desktop & utilities
  kitty github-cli \
  python # System python for uv bootstrap & system tools
  konsole dolphin ark kdeplasma-addons kde-graphics-spectacle \
  xdg-desktop-portal-kde qt6-wayland egl-wayland \
  kvantum kvantum-qt5 kvantum-qt6 \
  ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols papirus-icon-theme bibata-cursor-theme \
  # GPU & AI
  nvidia-dkms nvidia-utils nvidia-settings opencl-nvidia cuda cudnn nccl nvtop \
  nvidia-container-toolkit \
  docker docker-buildx docker-compose \
  distrobox \
  # diagnostics / media / sensors
  nvme-cli lm_sensors vulkan-tools ffmpeg \
  # shell plugins
  zsh-autosuggestions zsh-syntax-highlighting \
  # firewall & zram
  ufw systemd-zram-generator

# --- AUR helper (paru) if missing
if ! need paru; then
  echo "==> Installing AUR helper (paru-bin)"
  tmp="$(mktemp -d)"
  git -C "$tmp" clone https://aur.archlinux.org/paru-bin.git
  (cd "$tmp/paru-bin" && makepkg -si --noconfirm)
  rm -rf "$tmp"
fi

echo "==> AUR packages (mise, themes)"
# mise-bin: The modern, unified toolchain manager (replaces fnm, pyenv, etc.)
paru -S --needed --noconfirm \
  mise-bin \
  catppuccin-kde-git \
  catppuccin-kvantum-git \
  catppuccin-cursors-mocha \
  || echo "AUR theme install failed, continuing..."

echo "==> Default shell (zsh)"
if [ "${SHELL:-}" != "$(command -v zsh)" ]; then
  chsh -s "$(command -v zsh)" || true
fi

echo "==> Setting up 'mise' global toolchains"
# This installs and sets global default versions for core tools.
# Projects can override this with a local .tool-versions file.
if need mise; then
  mise use -g python@3.12
  mise use -g node@lts
  mise use -g ruff@latest
  mise use -g black@latest
  mise use -g pre-commit@latest
else
  echo "WARNING: 'mise' not found, skipping toolchain setup."
fi

echo "==> Creating default AI venv with 'uv' and PyTorch"
# Create a dedicated venv for AI work with PyTorch compiled for CUDA
# This assumes the 'cuda' package from pacman provides CUDA 12.1+
if need uv; then
  echo "Creating venv at ~/venvs/ai-torch..."
  uv venv "${HOME}/venvs/ai-torch"
  
  echo "Installing PyTorch (for CUDA 12.1+), Jupyter, and linters..."
  "${HOME}/venvs/ai-torch/bin/uv" pip install \
    jupyterlab \
    torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu121 \
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
  # Restart to apply
  sudo systemctl daemon-reload
  sudo systemctl restart systemd-zram-setup@zram0.service || true
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

cat <<'MSG'

✅ Bootstrap complete.

Next steps:
1) Log out and log back in (or reboot) to apply group/shell changes.
2. Your shell is now configured via your .zshrc dotfile.
3. Your default AI venv is ready. To use it:
   - Activate: source ~/venvs/ai-torch/bin/activate
   - Test PyTorch: python -c "import torch; print(torch.cuda.is_available())"
4. In VS Code: Ctrl+Shift+P → “Claude: Sign in”.
MSG

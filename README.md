# `cachyos-dev-ai-dotfiles` (KDE Plasma Edition)

A GitHub-ready, reproducible setup for **CachyOS + KDE Plasma (Wayland)** on high-end NVIDIA hardware, aimed at developers using **VS Code**, **Claude Code**, **mise (Node/Python)**, **uv (venvs)**, **Docker (GPU)**, and local AI via **Ollama** and **PyTorch (CUDA 13.0)**.

**Production-ready**: Works on both fresh installs and existing setups. Automatically backs up your configs before applying changes.

---

## ✨ Features

- **🎨 Riced KDE Plasma 6** (Wayland): Catppuccin Mocha theme, Bibata cursors, JetBrains Mono Nerd Font, Konsole profile
- **🐚 Productive shell**: zsh + starship + zoxide + fzf + eza + bat + ripgrep + direnv
- **🛠️ Modern dev toolchain**: 
  - `mise` for runtime management (Python 3.13, Node.js LTS)
  - `uv` for blazing-fast Python venv/package management
  - VS Code Insiders + extensions (including Claude AI)
  - GitHub CLI (`gh`)
- **🤖 AI/ML stack**: 
  - NVIDIA drivers (open-source) + CUDA 13.0
  - PyTorch 2.9.0 with CUDA 13.0 support
  - Docker + NVIDIA Container Toolkit
  - Ollama for local LLM inference (llama3.1, etc.)
  - Pre-configured AI venv at `~/venvs/ai-torch`
- **📦 Dotfiles via GNU Stow**: Clean, portable symlinks with automatic backup
- **🔒 Secure by default**: UFW firewall (deny incoming, allow outgoing)
- **⚡ Performance optimized**: zram (48GB for 96GB RAM systems), NVIDIA persistence daemon

> **Target OS**: CachyOS / Arch Linux  
> **Desktop**: KDE Plasma 6 (Wayland)  
> **Hardware**: NVIDIA GPU required for full AI/ML features

---

## 🚀 Quick Start

### Prerequisites
- Fresh or existing CachyOS/Arch Linux installation
- NVIDIA GPU (for CUDA features)
- Internet connection
- `sudo` access

### Installation

```bash
# 1) Clone the repo
cd ~
mkdir -p dev && cd dev
git clone https://github.com/seanGSISG/cachyos-dev-ai-dotfiles.git
cd cachyos-dev-ai-dotfiles

# 2) Run the full automated setup
make all

# 3) Reboot to apply all changes
sudo reboot

# 4) After reboot, verify everything works
make verify
```

That's it! The script handles everything automatically, including backing up any existing dotfiles.

---

## 📋 What the Installation Does

### Phase 1: System Setup (5-10 minutes)
- Updates all packages via `pacman`
- Removes legacy NVIDIA drivers (prevents conflicts)
- Installs base development tools: `git`, `base-devel`, `curl`, `wget`, `stow`
- Installs shell productivity tools: `zsh`, `starship`, `tmux`, `fzf`, `zoxide`, `fd`, `ripgrep`, `eza`, `bat`, `btop`
- Installs build tools: `cmake`, `ninja`, `clang`, `lld`
- Installs Python tooling: `mise`, `uv`, `ruff`, `black`, `pre-commit`
- Installs NVIDIA stack: `nvidia-open-dkms`, `nvidia-utils`, `cuda` (13.0), `cudnn`, `nccl`, `nvtop`
- Installs containerization: `docker`, `docker-buildx`, `docker-compose`, `nvidia-container-toolkit`, `distrobox`
- Installs KDE apps: `konsole`, `dolphin`, `ark`, `spectacle`
- Installs themes via AUR: Catppuccin, Kvantum, Bibata cursors
- Installs fonts: JetBrains Mono Nerd Font
- Sets up AUR helper (`paru`) if needed

### Phase 2: Python AI Environment (2-5 minutes)
- Configures `mise` with global toolchains:
  - Python 3.13 (officially supported by PyTorch 2.6+)
  - Node.js LTS
  - Ruff, Black, pre-commit
- Creates dedicated AI venv at `~/venvs/ai-torch` with:
  - **PyTorch 2.9.0 + CUDA 13.0** (latest stable with full Python 3.13 support)
  - `torchvision` and `torchaudio` (CUDA 13.0 builds)
  - JupyterLab for interactive development
  - Ruff and Black for linting/formatting
  - pre-commit for Git hooks

### Phase 3: Dotfiles Management (instant)
**🎯 NEW: Automatic Backup System**
- Detects existing dotfiles that would conflict with stow
- Backs them up to `~/dotfiles-backup-YYYYMMDD-HHMMSS/`
- Creates clean symlinks from `~/` to the repo's `dotfiles/` directory
- Works on both fresh installs (no backup needed) and existing setups

Files managed by stow:
- `.gitconfig` - Git configuration with delta integration
- `.zshrc` - Shell configuration with plugins and aliases
- `.config/starship.toml` - Shell prompt configuration
- `.config/kitty/kitty.conf` - Terminal emulator settings
- `.config/konsolerc` - Konsole terminal settings
- `.local/share/konsole/Cachy.profile` - Konsole color scheme
- `.config/Code - Insiders/User/settings.json` - VS Code settings

### Phase 4: System Configuration (instant)
- **Shell**: Sets zsh as default shell (requires logout to take effect)
- **Git**: Configures delta as the default pager for beautiful diffs
- **zram**: Creates 48GB compressed RAM swap (optimal for 96GB systems)
- **Docker**: Enables and starts Docker daemon, adds user to `docker` group
- **Ollama**: Installs and enables Ollama service for local LLM inference
- **NVIDIA**: Enables persistence daemon (reduces CUDA cold-start times)
- **Firewall**: Configures UFW to deny incoming, allow outgoing
- **Fonts**: Enables Nerd Font symbols system-wide
- **NVMe**: Enables periodic TRIM for SSD longevity

### Phase 5: KDE Plasma Customization (via `make rice-kde`)
- Applies Catppuccin Mocha color scheme
- Sets Kvantum theme
- Configures Bibata cursor theme
- Tweaks window decorations and effects
- Applies Konsole profile

---

## 🔧 Optional Features

Enable optional features via environment variables:

```bash
# Enable libvirt/KVM virtualization stack
ENABLE_VIRT=1 make all

# Set Nemo as default file manager (instead of Dolphin)
ENABLE_NEMO_DEFAULT=1 make all

# Enable both
ENABLE_VIRT=1 ENABLE_NEMO_DEFAULT=1 make all
```

---

## ✅ Verification

After rebooting, verify your installation:

```bash
# Verify PyTorch + CUDA
source ~/venvs/ai-torch/bin/activate
python -c "import torch; print(f'PyTorch: {torch.__version__}')"
# Expected: PyTorch: 2.9.0+cu130

python -c "import torch; print(f'CUDA available: {torch.cuda.is_available()}')"
# Expected: CUDA available: True

python -c "import torch; print(f'CUDA version: {torch.version.cuda}')"
# Expected: CUDA version: 13.0

# Run full verification suite
make verify
```

The `make verify` command tests:
- Docker + NVIDIA runtime (runs nvidia-smi in container)
- PyTorch CUDA functionality (runs `scripts/torch_test.py`)
- Ollama model download (pulls llama3.1:8b)

---

## 🎯 Next Steps

### 1. Sign into Claude in VS Code
1. Open VS Code Insiders
2. Press `Ctrl+Shift+P`
3. Type "Claude: Sign in"
4. Follow the authentication flow

### 2. Activate Your AI Environment
```bash
source ~/venvs/ai-torch/bin/activate
```

Your environment includes:
- PyTorch 2.9.0 with CUDA 13.0
- JupyterLab
- Ruff and Black (already configured)

### 3. Start a New Project
```bash
mkdir ~/dev/my-new-project && cd ~/dev/my-new-project

# Tell mise to use global toolchains
mise use python@3.13
mise use node@lts

# Create project-specific venv
uv venv
source .venv/bin/activate

# Install dependencies
uv pip install pandas numpy matplotlib
```

### 4. Explore Your Setup
```bash
# Check NVIDIA setup
nvidia-smi
nvcc --version

# Test Docker GPU access
docker run --rm --gpus all nvidia/cuda:13.0.0-base-ubuntu24.04 nvidia-smi

# Try Ollama
ollama pull llama3.1:8b
ollama run llama3.1:8b "Explain quantum computing in simple terms"

# Launch Jupyter
jupyter lab
```

---

## 📁 Repository Structure

```
cachyos-dev-ai-dotfiles/
├── README.md                    # This file
├── LICENSE                      # MIT License
├── bootstrap.sh                 # Main installation script
├── Makefile                     # Convenience targets
├── .editorconfig                # Editor configuration
│
├── scripts/
│   ├── torch_test.py           # PyTorch CUDA verification script
│   └── kde_tweaks.sh           # KDE Plasma customization script
│
├── dotfiles/                    # Managed by GNU Stow
│   ├── git/
│   │   └── .gitconfig          # Git configuration
│   ├── zsh/
│   │   └── .zshrc              # Zsh configuration
│   ├── starship/
│   │   └── .config/starship.toml
│   ├── kitty/
│   │   └── .config/kitty/kitty.conf
│   ├── konsolerc/
│   │   └── .config/konsolerc
│   ├── konsole-profile/
│   │   └── .local/share/konsole/Cachy.profile
│   └── vscode/
│       └── .config/Code - Insiders/User/settings.json
│
└── .github/
    └── workflows/
        └── ci.yml              # GitHub Actions (optional)
```

---

## 🔍 AI Stack Quick Reference

### NVIDIA / CUDA
```bash
# Check GPU status
nvidia-smi

# Check CUDA version
nvcc --version

# Monitor GPU usage
nvtop
```

### Docker with GPU
```bash
# Test GPU access in container
make docker-gpu-test

# Or manually:
docker run --rm --gpus all nvidia/cuda:13.0.0-base-ubuntu24.04 nvidia-smi
```

### Ollama (Local LLM)
```bash
# Check service status
sudo systemctl status ollama

# Pull a model
ollama pull llama3.1:8b
ollama pull codellama:13b
ollama pull mistral:latest

# Run a model
ollama run llama3.1:8b

# List installed models
ollama list
```

### PyTorch Development
```bash
# Activate the AI environment
source ~/venvs/ai-torch/bin/activate

# Run the included test script
python scripts/torch_test.py

# Start JupyterLab
jupyter lab

# Quick PyTorch test
python -c "
import torch
print(f'PyTorch version: {torch.__version__}')
print(f'CUDA available: {torch.cuda.is_available()}')
if torch.cuda.is_available():
    print(f'CUDA version: {torch.version.cuda}')
    print(f'GPU: {torch.cuda.get_device_name(0)}')
"
```

---

## 🛠️ Customization

### Change Python Version
Edit `bootstrap.sh` around line 95:
```bash
mise use -g python@3.12  # or 3.11, 3.10, etc.
```

Then update the venv creation around line 113:
```bash
uv venv "${HOME}/venvs/ai-torch" --python python3.12
```

### Change CUDA Version
If you have a different CUDA version installed, edit `bootstrap.sh` around line 119:
```bash
--extra-index-url https://download.pytorch.org/whl/cu121  # for CUDA 12.1
--extra-index-url https://download.pytorch.org/whl/cu118  # for CUDA 11.8
```

Check available versions: https://pytorch.org/get-started/locally/

### Adjust zram Size
Default is 48GB (50% of 96GB RAM). To change:
```bash
sudo vim /etc/systemd/zram-generator.conf.d/99-custom.conf
```

Change the `zram-size` value, then:
```bash
sudo systemctl daemon-reload
sudo systemctl stop systemd-zram-setup@zram0.service
sudo zramctl --reset /dev/zram0
sudo systemctl start systemd-zram-setup@zram0.service
```

---

## 🐛 Troubleshooting

### "Shell not changed" Error
This is normal if you entered the wrong password. Change manually:
```bash
chsh -s $(which zsh)
```

### PyTorch Can't Find CUDA
Ensure you rebooted and drivers are loaded:
```bash
nvidia-smi  # Should show your GPU

# Check driver module
lsmod | grep nvidia

# Restart services if needed
sudo systemctl restart nvidia-persistenced
sudo systemctl restart docker
```

### Stow Conflicts (if running manually)
The bootstrap script handles this automatically, but if you run `stow` manually:
```bash
# Backup your existing configs first
mkdir -p ~/dotfiles-backup
mv ~/.zshrc ~/dotfiles-backup/
mv ~/.gitconfig ~/dotfiles-backup/
# ... etc

# Then stow
cd dotfiles
stow -t ~ *
```

### Docker Permission Denied
You need to logout/login after installation to apply group membership:
```bash
# Or force group refresh
newgrp docker

# Verify
docker run hello-world
```

### Ollama Not Starting
```bash
# Check service status
sudo systemctl status ollama

# View logs
sudo journalctl -u ollama -f

# Restart service
sudo systemctl restart ollama
```

### Restore Original Dotfiles
If you want to revert to your pre-installation configs:
```bash
# Find your backup (timestamped directory)
ls ~/dotfiles-backup-*

# Remove symlinks
cd ~/dev/cachyos-dev-ai-dotfiles/dotfiles
stow -D -t ~ *

# Restore from backup
cp -a ~/dotfiles-backup-YYYYMMDD-HHMMSS/. ~/
```

### Clean Up Old Backups
```bash
# Remove all backups
rm -rf ~/dotfiles-backup-*

# Or use the Makefile (keeps 3 most recent)
make clean-backup
```

---

## 📦 Makefile Targets

```bash
make all           # Full setup: bootstrap + stow + kde-tweaks
make bootstrap     # Run bootstrap.sh only
make stow          # Stow dotfiles only (deprecated - bootstrap handles this)
make rice-kde      # Apply KDE customizations only
make verify        # Run all verification tests
make docker-gpu-test   # Test Docker GPU access
make torch-test    # Test PyTorch CUDA support
make ollama-pull   # Download Ollama model
make clean-backup  # Remove old dotfile backups (keeps 3 most recent)
```

---

## 🔄 Using on Multiple Machines

This setup is designed to work universally:

### On a Fresh Install
```bash
git clone https://github.com/YOUR_USERNAME/cachyos-dev-ai-dotfiles.git
cd cachyos-dev-ai-dotfiles
make all
sudo reboot
```

### On an Existing Setup
The script automatically:
1. Detects existing dotfiles
2. Backs them up to `~/dotfiles-backup-TIMESTAMP/`
3. Creates fresh symlinks
4. Works without conflicts

### Sync Changes Across Machines
```bash
# On machine A (after making changes)
cd ~/dev/cachyos-dev-ai-dotfiles
git add -A
git commit -m "Update zsh config"
git push

# On machine B
cd ~/dev/cachyos-dev-ai-dotfiles
git pull
# Changes are automatically reflected (dotfiles are symlinked)
```

---

## 🧪 Technical Details

### Why Python 3.13?
- **Official Support**: PyTorch 2.6+ fully supports Python 3.13 (released Oct 2024)
- **Performance**: Python 3.13 includes significant performance improvements
- **Current**: Matches modern development standards
- **Stable**: Has been stable for several months

### Why CUDA 13.0?
- **Latest**: CUDA 13.0 is the current stable release
- **Compatibility**: PyTorch 2.9.0 has full CUDA 13.0 support
- **Performance**: Includes latest optimizations
- **cu130 wheels**: Python 3.13 wheels are available for CUDA 13.0

### Why `--extra-index-url`?
The script uses `--extra-index-url` instead of `--index-url` when installing PyTorch. This is critical:

- `--index-url`: **Replaces** PyPI → Can't find packages like jupyterlab
- `--extra-index-url`: **Adds** PyTorch index → Can find everything

This is why jupyterlab, ruff, black, etc., install correctly.

---

## 📚 Additional Resources

- **PyTorch Documentation**: https://pytorch.org/docs/stable/
- **CUDA Documentation**: https://docs.nvidia.com/cuda/
- **Ollama Models**: https://ollama.com/library
- **mise Documentation**: https://mise.jdx.dev/
- **uv Documentation**: https://docs.astral.sh/uv/
- **Arch Wiki (NVIDIA)**: https://wiki.archlinux.org/title/NVIDIA
- **KDE Plasma**: https://kde.org/plasma-desktop/

---

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Commit your changes: `git commit -am 'Add feature'`
4. Push to the branch: `git push origin feature-name`
5. Submit a Pull Request

---

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **CachyOS Team** for the excellent Arch-based distribution
- **PyTorch Team** for comprehensive CUDA support
- **Anthropic** for Claude AI integration in VS Code
- **Ollama** for making local LLMs accessible
- **Catppuccin** for beautiful color schemes

---

## 📞 Support

- **Issues**: https://github.com/YOUR_USERNAME/cachyos-dev-ai-dotfiles/issues
- **Discussions**: https://github.com/YOUR_USERNAME/cachyos-dev-ai-dotfiles/discussions

---

**Made with ❤️ for the CachyOS + AI/ML development community**

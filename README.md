# `cachyos-dev-ai-dotfiles` (KDE Plasma Edition)

A GitHub-ready, reproducible setup for **CachyOS + KDE Plasma (Wayland)** on high-end NVIDIA hardware, aimed at developers using **VS Code**, **Claude Code**, **mise (Node/Python)**, **uv (venvs)**, **Docker (GPU)**, and local AI via **Ollama** and **PyTorch (CUDA)**.

---

## Features
- **Riced KDE Plasma 6** (Wayland): Global theme + icons + cursors + Konsole profile; one-shot script to apply tweaks via `kwriteconfig6`.
- **Productive shell**: zsh + starship + zoxide + fzf + eza + bat + ripgrep + direnv.
- **Dev toolchain**: `mise` (for Python, Node), `uv` (for venvs), VS Code + extensions (incl. `anthropic.claude-dev`), GitHub CLI.
- **AI stack**: NVIDIA drivers, CUDA, cudnn/nccl, NVIDIA Container Toolkit, Docker GPU, Ollama (systemd), PyTorch (CUDA wheels), quick test scripts.
- **Dotfiles via stow** for clean, portable symlinks.

> Target OS: **CachyOS / Arch**. Plasma/NVIDIA notes included. (No Hyprland.)

---

## Quick Start

```bash
# 1) Clone the repo
cd ~
mkdir -p dev && cd dev
git clone [https://github.com/seanGSISG/cachyos-dev-ai-dotfiles.git](https://github.com/seanGSISG/cachyos-dev-ai-dotfiles.git)
cd cachyos-dev-ai-dotfiles

# 2) Run the full setup via the Makefile
# This will:
#   1. Run bootstrap.sh (install packages)
#   2. Stow (symlink) dotfiles
#   3. Rice-KDE (apply themes/tweaks)
make all

# 3) Reboot
sudo reboot

# 4) Log in and verify everything
make verify

## After Verifying

1. **VS Code Sign-in**: Open VS Code, press `Ctrl+Shift+P`, and run **"Claude: Sign in"** to activate the AI extension.
2. **Activate AI Venv**: To use your PyTorch environment, run: `source ~/venvs/ai-torch/bin/activate`
3. **Start a Project**:
```bash
mkdir ~/dev/my-new-project && cd ~/dev/my-new-project
# Tell mise to use your global python/node
mise use -g python
mise use -g node
# Create a local venv for this project
uv venv
source .venv/bin/activate
```

## File Tree

```
cachyos-dev-ai-dotfiles/
├─ README.md
├─ LICENSE
├─ bootstrap.sh
├─ Makefile
├─ .editorconfig
├─ scripts/
│  ├─ torch_test.py
│  └─ kde_tweaks.sh
├─ dotfiles/
│  ├─ zsh/.zshrc
│  ├─ starship/.config/starship.toml
│  ├─ kitty/.config/kitty/kitty.conf
│  ├─ vscode/.config/Code/User/settings.json
│  ├─ konsolerc/.config/konsolerc
│  ├─ konsole-profile/.local/share/konsole/Cachy.profile
│  └─ git/.gitconfig
└─ .github/workflows/
   └─ ci.yml
```

## AI Stack Quick Reference

```bash
# NVIDIA / CUDA
nvidia-smi
nvcc --version

# Docker GPU test
make docker-gpu-test

# Ollama
sudo systemctl status ollama
ollama pull llama3.1:8b
ollama run llama3.1:8b

# PyTorch (CUDA)
# First, activate the venv:
source ~/venvs/ai-torch/bin/activate
# Then run the test:
python scripts/torch_test.py
```

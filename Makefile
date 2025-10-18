SHELL := /usr/bin/env bash
AI_VENV_PYTHON := "${HOME}/venvs/ai-torch/bin/python"

.PHONY: all bootstrap rice-kde verify docker-gpu-test torch-test ollama-pull clean-backup

# Main target - bootstrap now handles dotfile stowing automatically
all: bootstrap rice-kde
	@echo "✅ Full setup complete. Please 'sudo reboot' now."

bootstrap:
	@chmod +x bootstrap.sh
	@./bootstrap.sh

# Deprecated: bootstrap now handles stowing automatically
# Kept for backwards compatibility
stow:
	@echo "⚠️  Note: 'make stow' is deprecated - bootstrap.sh now handles dotfiles automatically"
	@echo "==> Stowing dotfiles (manual backup recommended)..."
	@cd dotfiles && stow --adopt -v -t "${HOME}" git zsh starship kitty konsolerc konsole-profile vscode

rice-kde:
	@echo "==> Applying KDE tweaks..."
	@bash scripts/kde_tweaks.sh

verify: docker-gpu-test torch-test ollama-pull
	@echo "----------------"
	@echo "✅ All verification checks passed."
	@echo "To use PyTorch, remember to run: source ~/venvs/ai-torch/bin/activate"

docker-gpu-test:
	@echo "==> Verifying Docker + NVIDIA Runtime..."
	@docker run --rm --gpus all nvidia/cuda:13.0.0-base-ubuntu24.04 nvidia-smi

torch-test:
	@echo "==> Verifying PyTorch + CUDA venv..."
	@if [ ! -f $(AI_VENV_PYTHON) ]; then \
		echo "Error: AI venv not found at $(AI_VENV_PYTHON)" >&2; \
		exit 1; \
	fi
	@$(AI_VENV_PYTHON) scripts/torch_test.py

ollama-pull:
	@echo "==> Pulling Ollama model (llama3.1:8b)..."
	@ollama pull llama3.1:8b

# Clean up old dotfile backups (keeps most recent 3)
clean-backup:
	@echo "==> Cleaning old dotfile backups (keeping 3 most recent)..."
	@cd ~ && ls -dt dotfiles-backup-* 2>/dev/null | tail -n +4 | xargs -r rm -rf
	@echo "✓ Cleanup complete"

SHELL := /usr/bin/env bash
AI_VENV_PYTHON := "${HOME}/venvs/ai-torch/bin/python"

.PHONY: all bootstrap stow rice-kde verify docker-gpu-test torch-test ollama-pull

all: bootstrap stow rice-kde
	@echo "✅ Full setup complete. Please 'sudo reboot' now."

bootstrap:
	@chmod +x bootstrap.sh
	@./bootstrap.sh

stow:
	@echo "==> Stowing dotfiles..."
	@cd dotfiles && stow -v -t "${HOME}" *

rice-kde:
	@echo "==> Applying KDE tweaks..."
	@bash scripts/kde_tweaks.sh

verify: docker-gpu-test torch-test ollama-pull
	@echo "----------------"
	@echo "✅ All verification checks passed."
	@echo "To use PyTorch, remember to run: source ~/venvs/ai-torch/bin/activate"

docker-gpu-test:
	@echo "==> Verifying Docker + NVIDIA Runtime..."
	@docker run --rm --gpus all nvidia/cuda:12.6.0-base-ubuntu24.04 nvidia-smi

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

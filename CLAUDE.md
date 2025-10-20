# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is a **CachyOS/Arch Linux dotfiles repository** that provides a complete, reproducible development environment optimized for:
- KDE Plasma 6 (Wayland) with Catppuccin theming
- NVIDIA GPU development (CUDA 13.0, PyTorch)
- Modern Python/Node.js development (`mise`, `uv`)
- AI/ML workflows (Ollama, PyTorch, Docker GPU)
- **Modern CLI tools** (bat, eza, fd, ripgrep, tmux, micro)
- **Global Claude Code integration** with Eric Buess-style PreCompact hooks

## Architecture Overview

### Hybrid Configuration Model

This repository uses a **global + per-project** approach:

**Global Configuration** (`~/.claude/`):
- `scripts/precompact-auto-context.py` - Auto-generates `.claude/CONTEXT_STATE.md` before compacting (works for ALL projects)
- `scripts/update-continue-work.py` - Auto-updates `.claude/CONTINUE_WORK.md` on Stop hook
- `settings.json` - Global hooks (PreCompact, Stop, /docs, /index integrations)

**Dotfiles Templates** (`dotfiles/`):
- Managed by GNU Stow for symlink-based deployment
- Templates include: git, zsh, starship, kitty, konsole, vscode, tmux, bat, ripgrep, micro, paru, ccline configs
- `dotfiles/claude/` contains templates for global Claude setup, hooks, and ccline
- `dotfiles/paru/` contains paru configuration with chroot builds enabled
- **50+ aliases** for modern CLI tools, Docker, and Git workflows

**Per-Project Files** (created by `claude-init`):
- `.claude/CONTEXT_STATE.md` - Auto-generated before compacting (gitignored)
- `.claude/CONTINUE_WORK.md` - Auto-updated on session end (tracked for team collaboration)
- `.claude/commands/` - Project-specific slash commands
- `.claude/hooks/` - Optional project-specific hooks

**Deployment Approach**:
- `bootstrap.sh` installs system packages and creates AI venv
- Stow creates symlinks from `~/` to `dotfiles/` (automatic backup of existing files)
- Global Claude hooks are installed to `~/.claude/` during bootstrap
- Enhanced `.zshrc` provides aliases: `c`, `cc`, `claude`, `claude-init`

### Key Components

1. **bootstrap.sh** - Main installation script (packages + Python venv)
2. **Makefile** - Convenience targets for setup, testing, verification
3. **scripts/init-claude-project.sh** - Per-project Claude Code initializer
4. **dotfiles/** - Stow-managed configuration files
5. **sync.sh** - Dotfiles sync utility (push/pull/status)

## Development Commands

### Setup & Installation

```bash
# Full setup (fresh install)
make all                    # Runs bootstrap + rice-kde
sudo reboot                 # Apply system changes

# After reboot - Reload shell to enable Claude Code
source ~/.zshrc
```

### Testing & Verification

```bash
# Run all verification tests
make verify                 # Runs docker-gpu-test + torch-test + ollama-pull

# Individual tests
make docker-gpu-test        # Test Docker + NVIDIA runtime
make torch-test             # Test PyTorch CUDA in venv
make ollama-pull            # Download Ollama model

# Manual PyTorch test
source ~/venvs/ai-torch/bin/activate
python scripts/torch_test.py
```

### Dotfiles Management

```bash
# Check sync status
./sync.sh status

# Push local changes to repo
./sync.sh push

# Pull repo changes to local
./sync.sh pull

# Clean old backups (keeps 3 most recent)
make clean-backup
```

### Project Initialization

```bash
# Initialize Claude Code in any project
cd ~/projects/my-app
claude-init                 # Creates .claude/ with slash commands

# Available aliases
c                           # claude-code
cc                          # claude-code
claude                      # claude-code
```

### Session Recovery & Context Management

The system auto-generates context files for seamless session recovery:

```bash
# After compacting conversation (PreCompact hook runs)
cat .claude/CONTEXT_STATE.md    # Full project state snapshot
# Contains: git status, recent changes, project structure

# After Claude Code session ends (Stop hook runs)
cat .claude/CONTINUE_WORK.md    # Work tracking + session context
# Contains: tasks, notes, recent files, uncommitted changes

# Resume work with full context
claude-code
# Say: "Read .claude/CONTEXT_STATE.md and help me continue"
```

**Auto-Update Behavior**:
- `CONTEXT_STATE.md` - Regenerated before each compact (gitignored)
- `CONTINUE_WORK.md` - Updated when session ends, preserves your edits (tracked in git)

## Architecture Notes

### Python Environment Strategy

- **Global toolchain**: Python 3.13, Node LTS (managed by `mise`)
- **AI venv**: `~/venvs/ai-torch` with PyTorch 2.9.0 + CUDA 13.0
- **Project venvs**: Created per-project with `uv venv`
- **Why Python 3.13**: Official PyTorch 2.6+ support, performance improvements
- **Why CUDA 13.0**: Latest stable, PyTorch 2.9.0 full support

### Package Installation Flow

1. System packages: `pacman` (official repos)
2. AUR packages: `paru` (installed if missing)
3. Toolchains: `mise` installs Python 3.13, Node LTS globally
4. Python packages: `uv` creates venvs and installs packages

### Dotfiles Deployment

- **Stow creates symlinks**: `~/` → `dotfiles/`
- **Automatic backup**: Existing files backed up to `~/dotfiles-backup-TIMESTAMP/`
- **No conflicts**: Works on both fresh installs and existing setups
- **Git-tracked**: All dotfiles in version control for reproducibility

### NVIDIA/CUDA Stack

- **Driver**: `nvidia-open-dkms` (open-source kernel module)
- **CUDA**: 13.0 with cuDNN, NCCL
- **Docker**: NVIDIA Container Toolkit for GPU access in containers
- **PyTorch**: Uses `--extra-index-url` (not `--index-url`) to preserve access to PyPI

### AUR Package Management (Paru)

**Chroot Builds** (enabled by default):
- Isolates AUR builds from mise-managed Python/Node versions
- Prevents conflicts with user environment variables
- Ensures reproducible builds matching Arch build system
- Requires `devtools` package (auto-installed)

**Configuration** (`~/.config/paru/paru.conf`):
- `Chroot = true` - Use chroot for all AUR builds
- `BottomUp = true` - Show dependencies first
- `CleanAfter = true` - Clean build directory after install

**Manual chroot setup** (optional):
```bash
# If you encounter chroot issues, reinitialize:
paru --gendb
```

**Why chroot matters**:
- Mise shims can interfere with AUR package builds
- Chroot provides clean, isolated build environment
- Prevents "command not found" errors with mise-managed tools

### Claude Code Integration

**CCometixLine Status Bar**:
- Custom status line showing: model, directory, git, context window, usage, session time
- Installed via: `npm install -g @cometix/ccline`
- Config: `~/.claude/ccline/config.toml`
- Custom theme: `~/.claude/ccline/themes/my-theme.toml` (Nerd Font mode)
- Repository: https://github.com/Haleclipse/CCometixLine

**Global Hook** (runs for all projects):
- `~/.claude/scripts/precompact-auto-context.py`
- Auto-generates `CONTEXT_STATE.md` before conversation compacting
- Captures: git status, recent changes, project structure, uncommitted work

**Per-Project Setup** (via `claude-init`):
- Creates `.claude/` with 6 slash commands: `/review`, `/commit`, `/analyze`, `/test`, `/dotfiles`, `/index`
- Optional: project-specific hooks in `.claude/hooks/`
- `CONTEXT_STATE.md` is gitignored

## Common Workflows

### Fresh Machine Setup
1. Clone repo: `git clone <repo> ~/dev/cachyos-dev-ai-dotfiles`
2. Run setup: `cd ~/dev/cachyos-dev-ai-dotfiles && make all`
3. Reboot: `sudo reboot`
4. Install integrations: `/docs` and `/index` (see above)
5. Test: `make verify`

### New Project Setup
1. Navigate: `cd ~/projects/new-app`
2. Initialize: `claude-init`
3. Start coding: `c` or `claude-code`
4. Generate index: `/index`

### Modifying Dotfiles
1. Edit files in `dotfiles/` subdirectories
2. Changes automatically reflected (symlinked)
3. Commit: `git add dotfiles/ && git commit`
4. Sync: `./sync.sh push` (optional)

### Session Recovery
- After compacting, `CONTEXT_STATE.md` is auto-generated
- Read it to resume work: `cat CONTEXT_STATE.md`
- Or: "Read CONTEXT_STATE.md and help me continue"

## File Structure

```
cachyos-dev-ai-dotfiles/
├── bootstrap.sh                # Main installation script
├── Makefile                    # Build/test/verify targets
├── sync.sh                     # Dotfiles sync utility
├── PROJECT_INDEX.json          # Auto-generated project index
│
├── scripts/
│   ├── init-claude-project.sh # Project initializer
│   ├── kde_tweaks.sh          # KDE Plasma customizations
│   └── torch_test.py          # PyTorch CUDA verification
│
├── dotfiles/                   # Stow-managed configs
│   ├── claude/                # Global Claude templates
│   │   ├── scripts/precompact-auto-context.py
│   │   └── settings.json
│   ├── git/.gitconfig
│   ├── zsh/                   # Enhanced shell (50+ aliases)
│   │   ├── .zshrc             # Main config + integrations
│   │   ├── aliases.sh         # Modern CLI, Docker, Git aliases
│   │   └── helpers.sh         # Help functions (ah, rg-help, etc.)
│   ├── tmux/.tmux.conf        # Mouse support, vi-mode
│   ├── bat/.config/bat/config # Syntax highlighting config
│   ├── ripgrep/.rgrc          # Ripgrep defaults
│   ├── micro/.config/micro/settings.json  # Mouse-friendly editor
│   ├── starship/.config/starship.toml
│   ├── kitty/.config/kitty/kitty.conf
│   ├── konsolerc/.config/konsolerc
│   ├── konsole-profile/.local/share/konsole/Cachy.profile
│   └── vscode/.config/Code - Insiders/User/settings.json
│
├── docs/                         # Documentation
│   ├── setup/                    # Setup and implementation guides
│   │   ├── IMPLEMENTATION_SUMMARY.md
│   │   ├── PARU_CHROOT_SETUP.md
│   │   └── CCLINE_INTEGRATION.md
│   └── user/                     # End-user documentation
│       ├── CLAUDE_CODE_GUIDE.md
│       ├── QUICK_COMMANDS.md
│       └── RECOVERY_INSTRUCTIONS.md
│
├── templates/                    # Template files
│   └── claude/                   # Claude Code templates
│       ├── QUICK_COMMANDS.md
│       └── RECOVERY_INSTRUCTIONS.md
│
└── [CLAUDE.md, README.md]        # Main docs (root)
```

## Important Notes

### Do NOT Run Directly
- **bootstrap.sh**: Run via `make all` (safer, includes post-steps)
- **stow**: Automated in bootstrap (manual use deprecated)

### Version-Specific Behavior
- **CUDA 13.0**: Uses `--extra-index-url` for PyTorch wheels
- **Python 3.13**: Requires PyTorch 2.6+ (this repo uses 2.9.0)
- **zsh**: Shell config uses Zsh-specific features (not Bash-compatible)

### Backup System
- Dotfile backups: `~/dotfiles-backup-YYYYMMDD-HHMMSS/`
- Clean old backups: `make clean-backup` (keeps 3 most recent)
- Restore: `cp -a ~/dotfiles-backup-*/. ~/` then `stow -D`

### Target Hardware
- **OS**: CachyOS / Arch Linux
- **Desktop**: KDE Plasma 6 (Wayland)
- **GPU**: NVIDIA required for AI/ML features
- **RAM**: zram configured for 48GB (optimized for 96GB systems)

## Reference

### CCometixLine (Status Bar)

**Overview**: Custom status bar for Claude Code showing real-time session metrics.

**Segments Enabled**:
- **Model** 🤖 - Current Claude model (Opus, Sonnet, etc.)
- **Directory** 📁 - Current working directory
- **Git** 🌿 - Branch name and status
- **Context Window** ⚡ - Token usage percentage
- **Usage** 📊 - API usage tracking with cache
- **Session** ⏱️ - Session duration timer

**Configuration**:
```bash
# Config location
~/.claude/ccline/config.toml

# Custom theme location
~/.claude/ccline/themes/my-theme.toml

# Available themes (installed by npm)
# - cometix, default, gruvbox, minimal, nord
# - powerline-dark, powerline-light
# - powerline-rose-pine, powerline-tokyo-night
```

**Customization**:
- Edit `config.toml` to change theme or segments
- Edit `my-theme.toml` to customize colors/icons
- Supports both plain text and Nerd Font icons
- Mode: `nerd_font` (requires Nerd Font terminal font)

**Settings Integration**:
```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/ccline/ccline",
    "padding": 0
  }
}
```

### Modern CLI Tools

**Replacements** (automatically aliased):
- `cat` → `bat` (syntax highlighting, colored output)
- `ls` → `eza` (better file listings with git status, icons)
- `find` → `fd` (faster, respects .gitignore)
- `vim` → `micro` (mouse-friendly, standard keybindings)

**Tool Integrations**:
- `bat` as `MANPAGER` (colored man pages)
- `fzf` keybindings: `Ctrl+R` (history), `Ctrl+T` (files), `Alt+C` (dirs)
- `fd` + `fzf` integration (respects .gitignore)

**Configurations**:
- `.tmux.conf` - Mouse support, vi-mode, Catppuccin theme
- `bat/config` - Monokai theme, line numbers, git integration
- `ripgrep/.rgrc` - Smart case, custom file types
- `micro/settings.json` - Mouse support, auto-save, syntax highlighting

### Key Aliases (50+ total)

**Modern CLI Tools**:
- `cat`, `b`, `bn`, `bp` (bat variants)
- `ll`, `la`, `lt`, `lg`, `lm` (eza variants)
- `fda`, `fdd`, `fdf` (fd variants)
- `rgi`, `rgh`, `rgpy`, `rgl` (ripgrep variants)

**Docker** (~25 aliases):
- `dps`, `dpsa`, `dex`, `dlogs`, `dlogsf`
- `dc`, `dcu`, `dcud`, `dcd`, `dcl`
- `dprune`, `dgpu`

**Git Extended** (~20 aliases):
- `gaa`, `gcm`, `gcam`, `gpl`, `gf`
- `grb`, `gst`, `gstp`, `gcl`, `gb`
- `gundo` (undo last commit)

**Editor**:
- `micro`, `edit`, `e`, `m` (micro editor)
- `vim` → redirected to micro (`ovim` for real vim)

### Helper Functions

Use these for quick reference:
- `alias-help` (or `ah`) - View all aliases
- `rg-help` - Ripgrep examples
- `docker-help` - Docker shortcuts
- `micro-help` - Micro editor keybindings
- `sysmon` - btop + nvtop side-by-side

### Key Environment Variables (set in .zshrc)
- `UV_PYTHON_VERSION=3.13` - Default Python for uv
- `EDITOR=micro` - Default editor (mouse-friendly)
- `VISUAL=micro` - Default visual editor
- `MANPAGER` - bat (colored man pages)
- `RIPGREP_CONFIG_PATH=$HOME/.rgrc` - Ripgrep config

### Slash Commands (after claude-init)
- `/review` - Code review with suggestions
- `/commit` - Smart git commits
- `/analyze` - Codebase analysis
- `/test` - Run tests
- `/dotfiles` - Dotfiles analysis (CachyOS-specific)
- `/index` - Generate PROJECT_INDEX.json
- `/docs [topic]` - Access documentation

### Package Managers
- `pacman` - Official Arch packages
- `paru` - AUR helper (auto-installed)
  - **Chroot builds enabled** - Isolates AUR builds from mise environment
  - Requires `devtools` package (installed by bootstrap)
  - Config: `~/.config/paru/paru.conf` (managed by stow)
- `mise` - Runtime version manager (Python, Node)
- `uv` - Fast Python package installer

## Project Index

Use `@PROJECT_INDEX.json` to reference the auto-generated project structure. Update with `/index` command.

## Documentation Reference

### End-User Documentation
Located in `docs/user/`:
- **CLAUDE_CODE_GUIDE.md** - Complete Claude Code usage guide
- **QUICK_COMMANDS.md** - Quick reference for aliases and commands
- **RECOVERY_INSTRUCTIONS.md** - Session recovery procedures

### Setup Documentation
Located in `docs/setup/` (for maintainers):
- **IMPLEMENTATION_SUMMARY.md** - Context management implementation
- **PARU_CHROOT_SETUP.md** - Paru chroot configuration
- **CCLINE_INTEGRATION.md** - Status bar integration

### Templates
Located in `templates/claude/`:
- Files copied by `claude-init` to new projects
- Maintained separately from documentation

**Quick Access**:
```bash
# View user guides
cat docs/user/QUICK_COMMANDS.md
cat docs/user/CLAUDE_CODE_GUIDE.md

# View setup guides
cat docs/setup/IMPLEMENTATION_SUMMARY.md
```

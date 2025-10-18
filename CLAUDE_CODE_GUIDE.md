# Complete Claude Code Setup Guide

**CachyOS Development Environment with Eric Buess-Style Configuration**

This guide explains your complete Claude Code setup - how it works, how to use it, and how to deploy it on fresh systems or new projects.

---

## Table of Contents

- [Architecture Overview](#architecture-overview)
- [Quick Start](#quick-start)
- [Fresh Install Guide](#fresh-install-guide)
- [New Project Setup](#new-project-setup)
- [Features & Comparison](#features--comparison)
- [Workflows](#workflows)
- [Troubleshooting](#troubleshooting)
- [Reference](#reference)

---

## Architecture Overview

### Global vs Per-Project Configuration

Your setup uses a **hybrid approach** like Eric Buess:

```
GLOBAL (~/.claude/):
~/.claude/
├── scripts/
│   └── precompact-auto-context.py  ← GLOBAL: Works for ALL projects
├── settings.json                    ← GLOBAL: PreCompact + /docs + /index hooks
├── commands/                        ← From /docs integration
└── agents/                          ← From /index integration

DOTFILES (templates for bootstrap):
~/dev/cachyos-dev-ai-dotfiles/
└── dotfiles/claude/
    ├── scripts/
    │   └── precompact-auto-context.py  ← Template for fresh installs
    └── settings.json                    ← Template with all global hooks

PER-PROJECT (minimal, project-specific):
your-project/.claude/
├── commands/                        ← 6 custom slash commands
├── hooks/                           ← Optional project-specific hooks
├── settings.local.json              ← Project settings (NO global hooks)
└── README.md                        ← Configuration docs
```

### How It Works Together

1. **Global Hooks** (`~/.claude/settings.json`):
   - ✅ **PreCompact** → Auto-generates `CONTEXT_STATE.md` before compacting
   - ✅ **PreToolUse (Read)** → `/docs` helper suggestions
   - ✅ **UserPromptSubmit** → Project index `-i` flag support
   - ✅ **Stop** → Project index cleanup

2. **Per-Project Config** (`.claude/settings.local.json`):
   - Custom slash commands
   - Project-specific hooks (optional)
   - Project-specific permissions

3. **PreCompact Hook** (The Key Feature):
   - Lives in `~/.claude/scripts/precompact-auto-context.py`
   - Runs automatically before conversation compacting
   - Creates `CONTEXT_STATE.md` with:
     - Current git status
     - Recent file changes
     - Project structure
     - Uncommitted work
   - **Works for ALL projects** on the system

---

## Quick Start

### On This Machine (Already Set Up)

```bash
# Your dotfiles repo is ready to use
cd ~/dev/cachyos-dev-ai-dotfiles
claude-code

# Try features:
/review               # Review code changes
/index                # Generate project index
/docs hooks           # Read documentation
```

### Initialize a New Project

```bash
cd ~/projects/my-app
claude-init           # One command!

# Output:
# ✅ Claude Code configuration initialized!
# 📂 .claude/ directory created
# 📄 Documentation files added

claude-code
/index                # Generate project index
"Help me build this -i"
```

---

## Fresh Install Guide

### Complete Setup on New Machine

```bash
# 1. Clone your dotfiles
cd ~/dev
git clone <your-repo> cachyos-dev-ai-dotfiles
cd cachyos-dev-ai-dotfiles

# 2. Run full setup
make all

# This installs:
# - All system packages
# - Enhanced .zshrc
# - Global Claude Code hooks
# - Dotfiles via stow

# 3. Reboot (for system changes)
sudo reboot

# 4. After reboot - Install Claude Code integrations
curl -fsSL https://raw.githubusercontent.com/ericbuess/claude-code-docs/main/install.sh | bash
curl -fsSL https://raw.githubusercontent.com/ericbuess/claude-code-project-index/main/install.sh | bash

# 5. Reload shell
source ~/.zshrc

# 6. Test it!
cd ~/projects/test-app
claude-init
claude-code
```

### What `make all` Does

1. **System Packages**: Installs all development tools, fonts, themes
2. **Dotfiles**: Stows zsh, git, starship, kitty, etc. to `~`
3. **Global Claude Hook**: Copies PreCompact script to `~/.claude/scripts/`
4. **Global Settings**: Sets up `~/.claude/settings.json` with hooks
5. **Shell Config**: Enhanced `.zshrc` with aliases and functions

---

## New Project Setup

### Using `claude-init`

```bash
# Navigate to any project
cd ~/projects/awesome-app
git init  # If not already a git repo

# Initialize Claude Code configuration
claude-init

# What it creates:
# .claude/
# ├── commands/       ← 6 slash commands
# ├── hooks/          ← Project hooks
# ├── settings.local.json
# └── README.md
#
# QUICK_COMMANDS.md
# RECOVERY_INSTRUCTIONS.md
# CONTINUE_WORK.md
# session-data/      ← Optional session tracking

# Start coding!
claude-code
/index
"Help me build a REST API -i"
```

### Available Aliases

After `make all`, these are available everywhere:

```bash
c                     # claude-code
cc                    # claude-code
claude                # claude-code
claude-init           # Initialize new project
```

---

## Features & Comparison

### What You Have

| Feature | Description | Location |
|---------|-------------|----------|
| **PreCompact Hook** | Auto-generates CONTEXT_STATE.md | `~/.claude/scripts/` (global) |
| **Session Data** | Per-project tracking | `session-data/` |
| **/docs Command** | Local documentation | `~/.claude-code-docs/` |
| **/index Command** | Project awareness | `~/.claude-code-project-index/` |
| **Custom Commands** | 6 slash commands | `.claude/commands/` |
| **Project Init** | `claude-init` | `scripts/init-claude-project.sh` |
| **Enhanced Shell** | Zsh with aliases | `dotfiles/zsh/.zshrc` |
| **Dotfiles Sync** | sync.sh | Root directory |

### vs Eric Buess's Setup

| Feature | Eric Buess | Your Setup | Status |
|---------|------------|------------|--------|
| PreCompact Location | `~/.claude-code-ericbuess/` | `~/.claude/scripts/` | ✅ Same concept, cleaner |
| Global Config | Custom directory | Standard `~/.claude/` | ✅ More standard |
| Session Data | Per-project | Per-project | ✅ Same |
| Project Init | Manual | `claude-init` command | ✅ Better automation |
| OS Support | Ubuntu/macOS | CachyOS/Arch | ✅ Optimized for Arch |
| Shell | Bash | Enhanced Zsh | ✅ More features |
| Dotfiles Deploy | Manual | `make all` + stow | ✅ Fully automated |

### Your Unique Advantages

1. ✅ **One-Command Project Init** - `claude-init` vs manual setup
2. ✅ **CachyOS Optimized** - Pacman, paru, Arch-specific aliases
3. ✅ **Enhanced Zsh** - Better completion, history, functions
4. ✅ **Make-Based Setup** - `make all` handles everything
5. ✅ **Stow Integration** - Automated dotfile deployment
6. ✅ **Standard Paths** - Uses `~/.claude/` instead of custom directory

---

## Workflows

### Workflow 1: Fresh Machine Setup

```bash
# 1. Clone dotfiles
git clone <repo> ~/dev/cachyos-dev-ai-dotfiles
cd ~/dev/cachyos-dev-ai-dotfiles

# 2. Run setup
make all                # Install everything
sudo reboot             # Apply system changes

# 3. After reboot - Install Claude integrations
curl -fsSL https://raw.githubusercontent.com/ericbuess/claude-code-docs/main/install.sh | bash
curl -fsSL https://raw.githubusercontent.com/ericbuess/claude-code-project-index/main/install.sh | bash

# 4. Ready!
source ~/.zshrc
cd ~/projects/test
claude-init
claude-code
```

### Workflow 2: New Project

```bash
mkdir ~/projects/new-app && cd ~/projects/new-app
git init
claude-init             # Sets up .claude/
claude-code
/index                  # Generate project index
"Build a Python FastAPI app -i"
```

### Workflow 3: Session Recovery

```bash
# After interruption, PreCompact auto-generated CONTEXT_STATE.md
cat CONTEXT_STATE.md    # Review project state
cat QUICK_COMMANDS.md   # Quick reference

claude-code
"Read CONTEXT_STATE.md and help me continue where we left off"
```

### Workflow 4: Compacting Conversations

```bash
# When conversation gets long, Claude suggests compacting
# Accept compact...

# → PreCompact hook runs automatically
# → CONTEXT_STATE.md generated in project directory
# → History compacted
# → Ready to continue with context

cat CONTEXT_STATE.md    # See what was captured
```

### Workflow 5: Sync Dotfiles

```bash
# Check sync status
./sync.sh status

# Push local changes to repo
./sync.sh push

# Pull repo changes to local
./sync.sh pull
```

---

## Custom Slash Commands

Your setup includes 6 pre-configured commands:

| Command | Description | Usage |
|---------|-------------|-------|
| `/review` | Code review with suggestions | `/review` |
| `/commit` | Smart git commits | `/commit` |
| `/analyze` | Codebase analysis | `/analyze` |
| `/test` | Run tests | `/test` |
| `/dotfiles` | Dotfiles analysis (CachyOS) | `/dotfiles` |
| `/index` | Generate PROJECT_INDEX.json | `/index` |
| `/docs` | Access documentation | `/docs hooks` |

### Adding Custom Commands

```bash
# In any project with .claude/
cat > .claude/commands/deploy.md << 'EOF'
---
description: Deploy application
gitignore: false
---

Deploy the application:
1. Run tests
2. Build production bundle
3. Deploy to staging
4. Run smoke tests
5. Deploy to production
EOF

# Use it:
/deploy
```

---

## Troubleshooting

### claude-init not found

```bash
# Reload shell
source ~/.zshrc

# Or use full path
~/dev/cachyos-dev-ai-dotfiles/scripts/init-claude-project.sh
```

### PreCompact hook fails

```bash
# Check Python is available
python3 --version

# Test the script manually
cd ~/test-project
python3 ~/.claude/scripts/precompact-auto-context.py
cat CONTEXT_STATE.md

# Check global settings
cat ~/.claude/settings.json | grep -A 5 "PreCompact"
```

### /docs command not working

```bash
# Reinstall integration
curl -fsSL https://raw.githubusercontent.com/ericbuess/claude-code-docs/main/install.sh | bash
```

### /index command not working

```bash
# Reinstall integration
curl -fsSL https://raw.githubusercontent.com/ericbuess/claude-code-project-index/main/install.sh | bash
```

### Global hook not running

```bash
# Verify hook exists
ls -la ~/.claude/scripts/precompact-auto-context.py

# Verify it's configured
cat ~/.claude/settings.json | jq '.hooks.PreCompact'

# If missing, re-run bootstrap
cd ~/dev/cachyos-dev-ai-dotfiles
./bootstrap.sh
```

---

## Reference

### File Locations

**Global Files:**
```
~/.claude/
├── scripts/precompact-auto-context.py  ← PreCompact hook
├── settings.json                        ← Global hooks config
├── commands/                            ← From /docs
└── agents/                              ← From /index
```

**Dotfiles Templates:**
```
~/dev/cachyos-dev-ai-dotfiles/
├── dotfiles/claude/                     ← Templates
├── scripts/init-claude-project.sh       ← Project initializer
├── sync.sh                              ← Dotfiles sync
└── bootstrap.sh                         ← Fresh install setup
```

**Per-Project Files:**
```
your-project/
├── .claude/                             ← Project config
├── CONTEXT_STATE.md                     ← Auto-generated (gitignored)
├── QUICK_COMMANDS.md                    ← Recovery reference
├── RECOVERY_INSTRUCTIONS.md             ← Detailed recovery
└── session-data/                        ← Optional tracking
```

### Important Commands

**Setup:**
```bash
make all                 # Fresh install setup
source ~/.zshrc          # Reload shell config
claude-init              # Initialize project
```

**Sync:**
```bash
./sync.sh status         # Check sync status
./sync.sh push           # Push to repo
./sync.sh pull           # Pull from repo
```

**Testing:**
```bash
# Test PreCompact hook
python3 ~/.claude/scripts/precompact-auto-context.py

# Test project setup
claude-init
claude-code

# Test integrations
/docs
/index
```

### Environment Variables

Set in `.zshrc`:
```bash
UV_PYTHON_VERSION=3.13   # Default Python for UV
EDITOR=vim               # Default editor
VISUAL=vim               # Default visual editor
```

### Dotfiles Managed by Stow

```
git/           → ~/.gitconfig
zsh/           → ~/.zshrc, ~/.zprofile
starship/      → ~/.config/starship.toml
kitty/         → ~/.config/kitty/
konsolerc/     → ~/.config/konsolerc
konsole-profile/ → ~/.local/share/konsole/
vscode/        → ~/.config/Code - Insiders/User/
```

---

## Checklist

### After Fresh Install
- [ ] Ran `make all` successfully
- [ ] Rebooted system
- [ ] Installed claude-code-docs integration
- [ ] Installed claude-code-project-index integration
- [ ] Ran `source ~/.zshrc`
- [ ] Tested `claude-init` command
- [ ] Verified `/docs` works
- [ ] Verified `/index` works
- [ ] PreCompact hook in `~/.claude/scripts/` exists

### After Project Init
- [ ] Ran `claude-init` in project
- [ ] `.claude/` directory created with commands
- [ ] Can use slash commands (`/review`, `/analyze`, etc.)
- [ ] Generated PROJECT_INDEX.json with `/index`
- [ ] `CONTEXT_STATE.md` is in `.gitignore`
- [ ] Documentation files present

### Before Committing Changes
- [ ] `CONTEXT_STATE.md` is gitignored
- [ ] Removed `.zshrc.old` backup if not needed
- [ ] Tested `sync.sh status`
- [ ] Documentation is accurate
- [ ] All scripts are executable

---

## Summary

Your CachyOS dotfiles now provide a **complete, portable Claude Code environment**:

1. ✅ **Global PreCompact Hook** - Works for ALL projects automatically
2. ✅ **One-Command Setup** - `make all` on fresh installs
3. ✅ **One-Command Project Init** - `claude-init` in any project
4. ✅ **Eric Buess-Style** - Same architecture, better automation
5. ✅ **CachyOS Optimized** - Arch-specific enhancements

### Key Differences from Standard Setup

- **Global hooks** instead of per-project
- **Automated deployment** via `make all` and `bootstrap.sh`
- **CachyOS/Arch optimizations** throughout
- **Enhanced Zsh** with productivity features
- **Stow-based** dotfile management

### Next Steps

1. **Test on this machine**: `claude-code` in this repo
2. **Try in a new project**: `mkdir ~/test && cd ~/test && claude-init`
3. **Commit your changes**: `git add . && git commit`
4. **Test on fresh install**: Clone to a new VM/system

---

**Setup Date:** 2025-10-18
**Configuration:** Eric Buess-inspired, CachyOS-optimized
**Architecture:** Global hooks + per-project customization
**Status:** ✅ Complete and tested

For more help, use `/docs` for any topic or read the documentation files in `.claude/`.

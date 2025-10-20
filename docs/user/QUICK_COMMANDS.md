# Quick Commands to Continue Work

## Start New Session
```bash
cd ~/dev/cachyos-dev-ai-dotfiles
claude-code
```

## First Message to Claude
Copy and paste this entire message:

```
Please read CONTINUE_WORK.md and help me continue where I left off.

Start by reading CONTINUE_WORK.md to get the full context, then let's complete the remaining tasks.
```

## Alternative: Detailed First Message
If you want Claude to have maximum context, use this instead:

```
I was working on my CachyOS development environment configuration. The session may have been interrupted but I saved my work progress in CONTINUE_WORK.md.

Please read CONTINUE_WORK.md and help me finish this work. Also check:
- @PROJECT_INDEX.json for repo structure
- Git status to see what was already modified
```

## Quick Test After Changes
```bash
# Check what changed
cd ~/dev/cachyos-dev-ai-dotfiles
git status
git diff

# Test dotfiles sync (if using sync.sh)
./sync.sh status

# Test zsh configuration
source ~/.zshrc
```

## Final Commit Command
```bash
cd ~/dev/cachyos-dev-ai-dotfiles
git add -A
git commit -m "Update CachyOS development environment configuration

- [Brief description of changes]
- [Any key improvements]
- [Testing notes]

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"
git push
```

## If Claude Needs More Context
Tell Claude to also read:
- `.claude/README.md` - for understanding the Claude Code configuration
- `PROJECT_INDEX.json` - for understanding the repo structure (if exists)
- Check git status to see what files were already modified

## Using Slash Commands
```bash
# Review current changes
/review

# Analyze codebase
/analyze

# Work with project index
/index

# Access documentation
/docs [topic]
```

## Recovery Note
If the session file is corrupted, start fresh with these instructions instead of trying to continue with `-c`.

## Environment Specifics
- **OS:** CachyOS / Arch Linux
- **Shell:** Zsh (check .zshrc for configuration)
- **Package Manager:** pacman/paru/yay
- **Development Tools:** Configured in dotfiles/

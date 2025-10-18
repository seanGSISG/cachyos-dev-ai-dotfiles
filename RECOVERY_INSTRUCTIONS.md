# Complete Session Recovery Instructions

## IMMEDIATE ACTION REQUIRED
Read this entire file first, then execute the tasks listed below. If a previous session was corrupted or interrupted, this file contains everything you need to continue.

## FILES TO READ FOR CONTEXT
Please read these files in this exact order to understand the project:
1. `/home/lsdmt/dev/cachyos-dev-ai-dotfiles/PROJECT_INDEX.json` - Overview of repo structure (if exists)
2. `/home/lsdmt/dev/cachyos-dev-ai-dotfiles/.claude/README.md` - Claude Code configuration
3. `/home/lsdmt/dev/cachyos-dev-ai-dotfiles/CONTINUE_WORK.md` - Current work state (if exists)

## PROJECT CONTEXT
- **Repository:** cachyos-dev-ai-dotfiles - CachyOS development environment configurations
- **Environment:** CachyOS / Arch Linux
- **Shell:** Zsh
- **Philosophy:** Maintain a clean, reproducible development environment

## EXECUTION CHECKLIST

When recovering from a session interruption:

### 1. Check Current State
```bash
cd ~/dev/cachyos-dev-ai-dotfiles
git status
git diff
```

### 2. Read Context Files
- [ ] Read PROJECT_INDEX.json (if exists)
- [ ] Read .claude/README.md
- [ ] Read CONTINUE_WORK.md (if exists)
- [ ] Check git log for recent commits

### 3. Identify Incomplete Work
Look for:
- Uncommitted changes in git
- TODO comments in code
- Files mentioned in CONTINUE_WORK.md
- Failed tests or builds

### 4. Resume Work
Based on context, complete the remaining tasks. Common patterns:
- Dotfile updates → Test with `source ~/.zshrc`
- Claude config changes → Test slash commands
- Sync script changes → Run `./sync.sh status`

## COMMON RECOVERY SCENARIOS

### Scenario 1: Dotfiles Update Interrupted
```bash
# Check what changed
git diff dotfiles/

# Test specific dotfile
source dotfiles/zsh/.zshrc

# Sync if needed
./sync.sh push
```

### Scenario 2: Claude Config Update Interrupted
```bash
# Check Claude settings
cat .claude/settings.local.json

# Test slash commands
/review

# Test hooks
ls -la .claude/hooks/
```

### Scenario 3: Uncommitted Work
```bash
# Review changes
git status
git diff

# Stage and commit
git add <files>
git commit -m "Description

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"
```

## ERROR CONTEXT (FYI Only)
If the previous session file corrupted, it's usually due to:
- Tool use/result misalignment
- Duplicate message IDs
- Interrupted network connections

Don't try to fix the corrupted session - start fresh with these instructions.

## ORIGINAL SESSION FILE REFERENCE
Corrupted session files are typically saved with `.original` extension in:
`~/.claude/projects/<project-hash>/`

You can extract information if needed:
```
Use Task tool with general-purpose agent to analyze the session file and extract relevant context, focusing on user messages and successful tool executions.
```

## VERIFICATION STEPS
After completing recovered work:
- [ ] All tests pass
- [ ] Configuration files are valid
- [ ] Git status is clean (or changes are intentional)
- [ ] Documentation is updated
- [ ] Changes are committed

## PREVENTION TIPS
To avoid needing recovery:
1. Commit work frequently
2. Keep CONTINUE_WORK.md updated
3. Use `/review` before making large changes
4. Test incrementally

## USING CLAUDE CODE FEATURES

### Project Index
```bash
# Generate or update index
/index

# Use with queries
"where is the zsh configuration handled? -i"
```

### Documentation
```bash
# Search docs
/docs hooks
/docs settings
/docs commands
```

### Slash Commands
```bash
/review          # Review current changes
/commit          # Create smart commit
/analyze         # Analyze codebase
/dotfiles        # CachyOS-specific dotfile analysis
```

## ENVIRONMENT-SPECIFIC NOTES

### CachyOS / Arch Linux
- Package manager: `pacman -S` or `paru -S` or `yay -S`
- Kernel: CachyOS optimized kernel
- Init system: systemd
- Shell: Zsh with custom configuration

### File Locations
- Dotfiles: `~/dev/cachyos-dev-ai-dotfiles/dotfiles/`
- Claude config: `~/.claude/` and `./.claude/`
- Zsh config: `~/.zshrc` or `dotfiles/zsh/.zshrc`

---
END OF INSTRUCTIONS - Start with reading the context files, then assess and complete remaining work.

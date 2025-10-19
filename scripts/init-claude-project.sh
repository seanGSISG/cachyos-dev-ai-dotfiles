#!/bin/bash
#
# Initialize Claude Code Configuration for New Projects
#
# This script sets up the complete Claude Code configuration from your dotfiles
# in any new project directory. Run this in any project where you want to use
# Claude Code with your custom configuration.
#
# Usage:
#   cd /path/to/new/project
#   ~/dev/cachyos-dev-ai-dotfiles/scripts/init-claude-project.sh
#
# Or create an alias in your .zshrc:
#   alias claude-init='~/dev/cachyos-dev-ai-dotfiles/scripts/init-claude-project.sh'
#

set -e

DOTFILES_DIR="${HOME}/dev/cachyos-dev-ai-dotfiles"
TEMPLATE_DIR="${DOTFILES_DIR}/.claude"
TARGET_DIR="$(pwd)/.claude"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Claude Code Project Initialization${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Check if we're in a git repo (recommended but not required)
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  Warning: Not in a git repository${NC}"
    echo -e "   Claude Code works best with git-tracked projects."
    read -p "   Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 1
    fi
fi

# Check if .claude already exists
if [ -d "$TARGET_DIR" ]; then
    echo -e "${YELLOW}⚠️  .claude directory already exists${NC}"
    read -p "   Overwrite existing configuration? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}   Backing up existing .claude to .claude.backup...${NC}"
        mv "$TARGET_DIR" "${TARGET_DIR}.backup.$(date +%s)"
    else
        echo "Aborted."
        exit 1
    fi
fi

# Check if template directory exists
if [ ! -d "$TEMPLATE_DIR" ]; then
    echo -e "${RED}✗ Template directory not found: $TEMPLATE_DIR${NC}"
    echo "  Make sure your dotfiles repository is at: $DOTFILES_DIR"
    exit 1
fi

# Copy the template
echo -e "${BLUE}📁 Copying Claude Code configuration...${NC}"
cp -r "$TEMPLATE_DIR" "$TARGET_DIR"

# Make hooks executable
echo -e "${BLUE}🔧 Setting up hooks...${NC}"
chmod +x "$TARGET_DIR"/hooks/*.sh 2>/dev/null || true

# Update settings to use project-relative paths
echo -e "${BLUE}⚙️  Configuring settings...${NC}"

# Check if settings.local.json exists, if not create from example
if [ ! -f "$TARGET_DIR/settings.local.json" ]; then
    if [ -f "$TARGET_DIR/settings.example.json" ]; then
        cp "$TARGET_DIR/settings.example.json" "$TARGET_DIR/settings.local.json"
    fi
fi

# Create session-data directory (optional)
mkdir -p session-data/{cache,machines}

# Copy documentation files if they don't exist
echo -e "${BLUE}📄 Setting up documentation...${NC}"
for doc in QUICK_COMMANDS.md RECOVERY_INSTRUCTIONS.md; do
    if [ -f "${DOTFILES_DIR}/${doc}" ] && [ ! -f "${doc}" ]; then
        cp "${DOTFILES_DIR}/${doc}" .
        echo -e "${GREEN}   ✓ Created ${doc}${NC}"
    fi
done

# Create CONTINUE_WORK.md template in .claude/ directory
if [ ! -f ".claude/CONTINUE_WORK.md" ]; then
    cat > .claude/CONTINUE_WORK.md << 'EOF'
# Continue Work

**Last Updated**: Auto-updated by Stop hook
**Manual Updates**: Add your tasks and notes below

## Current Task

_Describe what you're currently working on..._

## Completed

- [ ] Example completed task
- [ ] Another completed task

## Next Steps

- [ ] Next task to work on
- [ ] Another upcoming task

## Session Context

_This section is auto-updated when Claude Code stops_

## Notes

_Add any important notes, reminders, or context here..._

### Useful Commands

```bash
# Resume work
claude-code  # or: c, cc, claude

# Check project state
cat .claude/CONTEXT_STATE.md

# Review changes
git status
git diff

# Update project index
/index
```

---
*File is auto-updated by Stop hook. Manual edits in sections above are preserved.*
EOF
    echo -e "${GREEN}   ✓ Created .claude/CONTINUE_WORK.md template${NC}"
fi

# Add .claude/CONTEXT_STATE.md to .gitignore if not already there
if [ -f ".gitignore" ]; then
    if ! grep -q "^.claude/CONTEXT_STATE.md$" .gitignore; then
        echo "" >> .gitignore
        echo "# Claude Code auto-generated files" >> .gitignore
        echo ".claude/CONTEXT_STATE.md" >> .gitignore
        echo -e "${GREEN}   ✓ Added .claude/CONTEXT_STATE.md to .gitignore${NC}"
    fi
    # Also add legacy CONTEXT_STATE.md in root for backward compatibility
    if ! grep -q "^CONTEXT_STATE.md$" .gitignore; then
        echo "CONTEXT_STATE.md  # Legacy location (use .claude/ instead)" >> .gitignore
    fi
else
    cat > .gitignore << 'EOF'
# Claude Code auto-generated files
.claude/CONTEXT_STATE.md
CONTEXT_STATE.md  # Legacy location (use .claude/ instead)

# Note: .claude/CONTINUE_WORK.md is tracked for team collaboration
EOF
    echo -e "${GREEN}   ✓ Created .gitignore${NC}"
fi

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ Claude Code configuration initialized!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BLUE}📂 Project Structure:${NC}"
tree -L 2 .claude 2>/dev/null || find .claude -maxdepth 2 -type f -o -type d

echo ""
echo -e "${BLUE}🚀 Available Commands:${NC}"
echo -e "   ${GREEN}/review${NC}       - Review current code changes"
echo -e "   ${GREEN}/commit${NC}       - Create smart git commits"
echo -e "   ${GREEN}/analyze${NC}      - Analyze codebase structure"
echo -e "   ${GREEN}/test${NC}         - Run tests"
echo -e "   ${GREEN}/dotfiles${NC}     - Analyze dotfiles (CachyOS)"
echo -e "   ${GREEN}/index${NC}        - Generate PROJECT_INDEX.json"
echo -e "   ${GREEN}/docs [topic]${NC} - Access documentation"
echo ""
echo -e "${BLUE}⚙️  Global Configuration:${NC}"
echo -e "   ${GREEN}✓${NC} PreCompact hook → Configured in ~/.claude/settings.json"
echo -e "   ${GREEN}✓${NC} Auto-generates CONTEXT_STATE.md before compacting"
echo -e "   ${GREEN}✓${NC} /docs and /index commands → Already installed globally"
echo ""
echo -e "${BLUE}🎯 Next Steps:${NC}"
echo -e "   1. Run: ${GREEN}claude-code${NC}"
echo -e "   2. Try: ${GREEN}/index${NC} to create project index"
echo -e "   3. Try: ${GREEN}/analyze${NC} to understand codebase"
echo ""
echo -e "${BLUE}📖 Documentation:${NC}"
echo -e "   ${GREEN}cat .claude/README.md${NC}       - Configuration guide"
echo -e "   ${GREEN}cat QUICK_COMMANDS.md${NC}       - Quick reference"
echo -e "   ${GREEN}cat RECOVERY_INSTRUCTIONS.md${NC} - Recovery procedures"
echo ""
echo -e "${YELLOW}💡 Tip:${NC} PreCompact hook works globally for all projects!"
echo -e "   When Claude Code compacts conversation history, CONTEXT_STATE.md"
echo -e "   will be auto-generated in your project directory."
echo ""

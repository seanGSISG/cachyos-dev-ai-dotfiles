# Claude Code Configuration

This directory contains Claude Code configuration for the CachyOS development environment.

## Structure

```
.claude/
├── README.md                 # This file
├── settings.example.json     # Example configuration
├── CONTINUE_WORK.md          # Session context and tasks
├── commands/                 # Custom slash commands
│   ├── review.md            # Code review command
│   ├── commit.md            # Git commit helper
│   ├── analyze.md           # Codebase analysis
│   ├── test.md              # Test runner
│   └── docs.md              # Documentation access
└── hooks/                    # Automation hooks
    ├── user-prompt-submit-hook.sh
    └── tool-use-hook.sh
```

## Available Commands

### `/review`
Reviews current code changes and suggests improvements for quality, security, and performance.

### `/commit`
Creates well-formatted git commits following best practices.

### `/analyze`
Performs comprehensive codebase analysis including structure, dependencies, and architecture.

### `/test`
Detects and runs the project's test suite with result analysis.

### `/docs [topic]`
Access and search project documentation.

## Hooks

Hooks are shell scripts that run in response to Claude Code events:

- **user-prompt-submit-hook.sh**: Runs when you submit a prompt
- **tool-use-hook.sh**: Runs before tool execution

Edit these files to add custom validation, logging, or automation.

## Optional Integrations

### Eric Buess's Claude Code Tools

#### 1. Claude Code Docs (Recommended)
Local documentation mirror with `/docs` command:
```bash
curl -fsSL https://raw.githubusercontent.com/ericbuess/claude-code-docs/main/install.sh | bash
```

#### 2. Project Index
Architectural awareness with `/index` command:
```bash
curl -fsSL https://raw.githubusercontent.com/ericbuess/claude-code-project-index/main/install.sh | bash
```

## Configuration

### Adding Custom Commands

Create a new `.md` file in `commands/`:
```markdown
---
description: Brief description of command
gitignore: false
---

Your command instructions here...
```

### Permissions

Configure permissions in `settings.local.json` (create from `settings.example.json`):
- Approve/deny specific tools and domains
- Set allowed/blocked websites for WebFetch
- Customize hook behavior

## Resources

- [Claude Code Documentation](https://docs.claude.com/en/docs/claude-code)

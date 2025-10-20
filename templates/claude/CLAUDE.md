# Project Context

## Recovery After Compacting

**Read these files to resume work:**
1. `.claude/CONTEXT_STATE.md` - Auto-generated before compacting (git status, recent changes, project state)
2. `.claude/CONTINUE_WORK.md` - Updated on stop (current tasks, session context)

## Hooks System

- **PreCompact**: Generates CONTEXT_STATE.md with project state snapshot
- **Stop**: Updates CONTINUE_WORK.md with session context

## Quick Commands

- `/index` - Generate PROJECT_INDEX.json for architectural awareness
- `/docs [topic]` - Access documentation (requires claude-code-docs installed)

**After compacting**: Start by reading `.claude/CONTEXT_STATE.md` to understand current project state.

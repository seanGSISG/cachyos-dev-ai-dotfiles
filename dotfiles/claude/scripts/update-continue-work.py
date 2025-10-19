#!/usr/bin/env python3
"""
Stop hook for updating CONTINUE_WORK.md with session context.

This hook runs when Claude Code session stops/exits.
It updates CONTINUE_WORK.md with:
- Session timestamp
- Recent file changes
- Git status
- Recently modified files

Inspired by Eric Buess's context management approach.
"""

import os
import subprocess
import json
from datetime import datetime
from pathlib import Path

def run_command(cmd, capture_output=True, timeout=5):
    """Run a shell command and return output."""
    try:
        result = subprocess.run(
            cmd,
            shell=True,
            capture_output=capture_output,
            text=True,
            timeout=timeout
        )
        return result.stdout.strip() if result.returncode == 0 else ""
    except (subprocess.TimeoutExpired, Exception):
        return ""

def get_git_status():
    """Get brief git status."""
    if not run_command("git rev-parse --git-dir 2>/dev/null"):
        return None

    return {
        'branch': run_command("git branch --show-current"),
        'status': run_command("git status --short"),
        'uncommitted': bool(run_command("git status --short")),
    }

def get_recent_files(hours=24):
    """Get files modified in the last N hours."""
    files = run_command(
        f"find . -type f -mmin -{hours*60} -not -path '*/\\.git/*' "
        f"-not -path '*/node_modules/*' -not -path '*/__pycache__/*' "
        f"-not -path '*/.claude/*' 2>/dev/null | head -20"
    )
    return [f.strip() for f in files.split('\n') if f.strip()] if files else []

def parse_existing_continue_work(file_path):
    """Parse existing CONTINUE_WORK.md to preserve user content."""
    if not file_path.exists():
        return None

    try:
        with open(file_path, 'r') as f:
            content = f.read()

        # Extract sections (basic parsing)
        sections = {
            'current_task': '',
            'completed': [],
            'next_steps': [],
            'notes': ''
        }

        # Simple section extraction
        current_section = None
        for line in content.split('\n'):
            if line.startswith('## Current Task'):
                current_section = 'current_task'
            elif line.startswith('## Completed'):
                current_section = 'completed'
            elif line.startswith('## Next Steps'):
                current_section = 'next_steps'
            elif line.startswith('## Notes'):
                current_section = 'notes'
            elif current_section and line.strip() and not line.startswith('#'):
                if current_section in ['completed', 'next_steps']:
                    if line.strip().startswith('- ['):
                        sections[current_section].append(line.strip())
                else:
                    sections[current_section] += line + '\n'

        return sections
    except Exception:
        return None

def update_continue_work():
    """Update CONTINUE_WORK.md with session information."""
    cwd = Path.cwd()
    claude_dir = cwd / '.claude'

    # Only proceed if .claude directory exists
    if not claude_dir.exists() or not claude_dir.is_dir():
        return  # Silent exit - not a Claude Code project

    continue_work_path = claude_dir / 'CONTINUE_WORK.md'
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    # Parse existing content to preserve user input
    existing = parse_existing_continue_work(continue_work_path)

    # Get session information
    git_status = get_git_status()
    recent_files = get_recent_files(hours=1)  # Last hour

    # Build content
    content = f"""# Continue Work

**Last Updated**: {timestamp}
**Auto-updated**: Stop hook

## Current Task

"""

    # Preserve existing task if available
    if existing and existing['current_task'].strip():
        content += existing['current_task'].strip() + "\n"
    else:
        content += "_Add your current task here..._\n"

    content += "\n## Completed\n\n"

    # Preserve existing completed items
    if existing and existing['completed']:
        for item in existing['completed']:
            content += item + "\n"
    else:
        content += "- [ ] _Tasks will appear here..._\n"

    content += "\n## Next Steps\n\n"

    # Preserve existing next steps
    if existing and existing['next_steps']:
        for item in existing['next_steps']:
            content += item + "\n"
    else:
        content += "- [ ] _Next steps will appear here..._\n"

    # Add session context
    content += "\n## Session Context\n\n"
    content += f"**Session Ended**: {timestamp}\n\n"

    if git_status and git_status['uncommitted']:
        content += "**⚠️ Uncommitted Changes**:\n```\n"
        content += git_status['status'][:500]  # Limit length
        content += "\n```\n\n"

    if recent_files:
        content += "**Recently Modified Files** (last hour):\n"
        for f in recent_files[:10]:  # Limit to 10 files
            content += f"- `{f}`\n"
        content += "\n"

    content += "\n## Notes\n\n"

    # Preserve existing notes
    if existing and existing['notes'].strip():
        content += existing['notes'].strip() + "\n"
    else:
        content += "_Add session notes here..._\n"

    content += f"""
---

### Session Recovery

To resume work:
1. Read `.claude/CONTEXT_STATE.md` for full project state
2. Review uncommitted changes: `git status && git diff`
3. Check `PROJECT_INDEX.json` for architectural context
4. Continue with: `claude-code` or `c`

---
*Auto-updated by Stop hook - {timestamp}*
"""

    # Write to file
    try:
        with open(continue_work_path, 'w') as f:
            f.write(content)
        print(f"✓ Updated .claude/CONTINUE_WORK.md")
    except Exception as e:
        print(f"✗ Failed to update CONTINUE_WORK.md: {e}")

if __name__ == "__main__":
    update_continue_work()

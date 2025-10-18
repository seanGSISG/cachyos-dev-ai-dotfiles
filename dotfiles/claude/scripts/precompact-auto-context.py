#!/usr/bin/env python3
"""
Auto-generate CONTEXT_STATE.md before compacting chat history.

This hook runs before Claude Code compacts the conversation history.
It creates a CONTEXT_STATE.md file that captures the current state of work,
making it easier to resume after compacting.

Inspired by Eric Buess's claude-ericbuess configuration.
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

def get_git_info():
    """Get current git repository information."""
    info = {}

    # Check if we're in a git repo
    if run_command("git rev-parse --git-dir 2>/dev/null"):
        info['branch'] = run_command("git branch --show-current")
        info['commit'] = run_command("git rev-parse --short HEAD")
        info['status'] = run_command("git status --short")
        info['diff_summary'] = run_command("git diff --stat")

        # Get recent commits
        info['recent_commits'] = run_command(
            "git log --oneline --decorate -n 5"
        )

        # Check for uncommitted changes
        info['has_changes'] = bool(info['status'])

    return info

def get_project_info():
    """Get project-specific information."""
    info = {}
    cwd = os.getcwd()

    info['working_directory'] = cwd
    info['project_name'] = os.path.basename(cwd)

    # Check for common project files
    project_files = [
        'package.json', 'requirements.txt', 'Cargo.toml',
        'go.mod', 'Makefile', 'CMakeLists.txt', 'pom.xml',
        'build.gradle', 'setup.py', 'pyproject.toml'
    ]

    info['project_files'] = [
        f for f in project_files if os.path.exists(f)
    ]

    # Check for PROJECT_INDEX.json
    if os.path.exists('PROJECT_INDEX.json'):
        try:
            with open('PROJECT_INDEX.json', 'r') as f:
                index_data = json.load(f)
                info['has_project_index'] = True
                info['index_summary'] = {
                    'total_files': len(index_data.get('files', [])),
                    'updated': index_data.get('metadata', {}).get('updated', 'unknown')
                }
        except:
            info['has_project_index'] = False

    return info

def get_recent_activity():
    """Get information about recent file activity."""
    # Get recently modified files (last 24 hours)
    recent_files = run_command(
        "find . -type f -mtime -1 -not -path '*/\\.git/*' -not -path '*/node_modules/*' -not -path '*/__pycache__/*' | head -20"
    )

    return recent_files.split('\n') if recent_files else []

def generate_context_state():
    """Generate CONTEXT_STATE.md with current project state."""
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    git_info = get_git_info()
    project_info = get_project_info()
    recent_files = get_recent_activity()

    # Build the markdown content
    content = f"""# CONTEXT_STATE.md

**Auto-generated**: {timestamp}
**Purpose**: Captures project state before chat history compacting

## Current Session State

### Project Information
- **Working Directory**: `{project_info['working_directory']}`
- **Project Name**: {project_info['project_name']}

"""

    # Git information
    if git_info:
        content += f"""### Git Status
- **Branch**: {git_info.get('branch', 'N/A')}
- **Latest Commit**: {git_info.get('commit', 'N/A')}
- **Has Uncommitted Changes**: {'Yes' if git_info.get('has_changes') else 'No'}

"""

        if git_info.get('status'):
            content += f"""#### Uncommitted Changes
```
{git_info['status']}
```

"""

        if git_info.get('diff_summary'):
            content += f"""#### Diff Summary
```
{git_info['diff_summary']}
```

"""

        if git_info.get('recent_commits'):
            content += f"""#### Recent Commits
```
{git_info['recent_commits']}
```

"""

    # Project structure
    if project_info.get('project_files'):
        content += f"""### Project Structure
Detected project files:
"""
        for pf in project_info['project_files']:
            content += f"- `{pf}`\n"
        content += "\n"

    # Project index info
    if project_info.get('has_project_index'):
        idx_summary = project_info['index_summary']
        content += f"""### Project Index
- **Status**: Available
- **Files Indexed**: {idx_summary['total_files']}
- **Last Updated**: {idx_summary['updated']}

💡 Use `/index` to regenerate or `[query] -i` for index-aware queries.

"""

    # Recent activity
    if recent_files:
        content += f"""### Recent File Activity
Files modified in the last 24 hours:
"""
        for rf in recent_files[:10]:  # Limit to 10 files
            content += f"- `{rf}`\n"
        content += "\n"

    # Instructions for resuming
    content += f"""## How to Resume Work

1. **Review this document** to understand the current state
2. **Check git status** to see what was being worked on
3. **Read PROJECT_INDEX.json** (if available) for architectural context
4. **Use `/review`** to see detailed code changes
5. **Reference CONTINUE_WORK.md** if it exists for specific tasks

## Quick Commands

```bash
# See current changes
git status
git diff

# Review recent work
/review

# Continue with context
"Help me continue where we left off. Check CONTEXT_STATE.md for current state."
```

## Notes

- This file is auto-generated before chat compacting
- Update CONTINUE_WORK.md manually for specific task tracking
- Use PROJECT_INDEX.json for architectural awareness
- Check QUICK_COMMANDS.md for session recovery procedures

---
*Generated by PreCompact hook - {timestamp}*
"""

    # Write to file
    output_file = Path.cwd() / 'CONTEXT_STATE.md'
    try:
        with open(output_file, 'w') as f:
            f.write(content)
        print(f"✓ Generated CONTEXT_STATE.md")
        return True
    except Exception as e:
        print(f"✗ Failed to generate CONTEXT_STATE.md: {e}")
        return False

if __name__ == "__main__":
    generate_context_state()

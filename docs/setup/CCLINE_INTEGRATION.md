# CCometixLine Integration

**Date**: 2025-10-19
**Status**: ✅ Complete

## Overview

Successfully integrated CCometixLine custom status bar into the CachyOS dotfiles repository. The status line provides real-time session metrics for Claude Code.

## What is CCometixLine?

A customizable status bar for Claude Code that displays:
- 🤖 **Model** - Current Claude model (Opus, Sonnet, etc.)
- 📁 **Directory** - Current working directory
- 🌿 **Git** - Branch name and status
- ⚡ **Context Window** - Token usage percentage
- 📊 **Usage** - API usage tracking with cache
- ⏱️ **Session** - Session duration timer

**Repository**: https://github.com/Haleclipse/CCometixLine

## Implementation

### Files Added to Dotfiles

1. **`dotfiles/claude/.claude/ccline/config.toml`**
   - Points to custom theme: `theme = "my-theme"`
   - Mode: `nerd_font` (uses Nerd Font icons)
   - Separator: ` | `

2. **`dotfiles/claude/.claude/ccline/themes/my-theme.toml`**
   - Custom color scheme
   - Enabled segments: model, directory, git, context_window, usage, session
   - Disabled segments: cost, output_style
   - Uses 256-color palette

### Files Modified

1. **`~/.claude/settings.json`** (deployed)
   - Fixed JSON structure (statusLine at root level)
   - Added statusLine configuration

2. **`dotfiles/claude/settings.json`** (template)
   - Already had correct structure
   - StatusLine properly configured

3. **`bootstrap.sh`**
   - Added ccline installation after mise setup
   - Command: `npm install -g @cometix/ccline`

4. **`CLAUDE.md`**
   - Documented ccline integration
   - Added detailed configuration reference
   - Updated dotfiles list

## Installation

### Fresh Machine

CCometixLine is automatically installed during bootstrap:

```bash
# Run full setup
make all

# ccline is installed after mise/Node setup
# Binary created at: ~/.claude/ccline/ccline
# Config deployed via stow from dotfiles/
```

### Manual Installation

```bash
# Install ccline via npm
npm install -g @cometix/ccline

# Verify installation
ccline --version
# Should show: ccline 1.0.8

# Check binary location
which ccline
# Should show mise-managed path or ~/.claude/ccline/ccline
```

## Configuration

### Directory Structure

```
~/.claude/ccline/
├── ccline              # Standalone binary (8.5MB)
├── config.toml         # Main config (from dotfiles)
└── themes/
    ├── my-theme.toml   # Custom theme (from dotfiles)
    ├── cometix.toml    # Default themes
    ├── default.toml    # (installed by npm)
    ├── gruvbox.toml
    ├── minimal.toml
    ├── nord.toml
    └── powerline-*.toml
```

### Config File (`config.toml`)

```toml
theme = "my-theme"

[style]
mode = "nerd_font"      # Requires Nerd Font terminal font
separator = " | "       # Segment separator
```

### Custom Theme (`my-theme.toml`)

**Segments Configuration**:

| Segment | Icon | Color | Enabled |
|---------|------|-------|---------|
| Model | 🤖 `` | Orange (c256: 208) | ✅ |
| Directory | 📁 `󰉋` | Tan (c256: 222/216) | ✅ |
| Git | 🌿 | Green (c256: 26/34) | ✅ |
| Context Window | ⚡ `` | Yellow (c256: 184/208) | ✅ |
| Usage | 📊 `󰪞` | Cyan (c256: 97) | ✅ |
| Cost | 💰 `` | Orange (c256: 214) | ❌ |
| Session | ⏱️ `󱦻` | Gray (c16: 8) | ✅ |
| Output Style | 🎯 `󱋵` | Blue (c256: 109) | ❌ |

### Settings Integration

**Location**: `~/.claude/settings.json`

```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/ccline/ccline",
    "padding": 0
  },
  "hooks": {
    // ... hooks configuration
  }
}
```

**Important**:
- `statusLine` is a **top-level property**, not nested in hooks
- Use full path `~/.claude/ccline/ccline` for reliability

## Customization

### Change Theme

Edit `~/.claude/ccline/config.toml`:
```toml
theme = "gruvbox"  # or: cometix, default, minimal, nord, powerline-*
```

Available themes installed by npm:
- `cometix` - Default colorful theme
- `default` - Basic theme
- `gruvbox` - Gruvbox color scheme
- `minimal` - Minimalist theme
- `nord` - Nord color scheme
- `powerline-dark` - Powerline style (dark)
- `powerline-light` - Powerline style (light)
- `powerline-rose-pine` - Rose Pine colors
- `powerline-tokyo-night` - Tokyo Night colors

### Modify Custom Theme

Edit `~/.claude/ccline/themes/my-theme.toml`:

**Enable/Disable Segments**:
```toml
[[segments]]
id = "cost"
enabled = true  # Change to true to enable
```

**Change Colors** (256-color mode):
```toml
[segments.colors.icon]
c256 = 208  # Orange (0-255)

[segments.colors.text]
c256 = 208  # Match icon or use different color
```

**Change Icons**:
```toml
[segments.icon]
plain = "💰"      # Plain text fallback
nerd_font = ""  # Nerd Font icon
```

### Change Display Mode

Edit `config.toml`:
```toml
[style]
mode = "plain"      # Use plain text icons (no Nerd Fonts required)
# or
mode = "nerd_font"  # Use Nerd Font icons (requires Nerd Font)
```

## Usage Information Segment

The **Usage** segment shows API usage tracking:

**Configuration** (in `my-theme.toml`):
```toml
[[segments]]
id = "usage"
enabled = true

[segments.options]
timeout = 2                              # API request timeout
api_base_url = "https://api.anthropic.com"
cache_duration = 180                     # Cache for 3 minutes
```

**What it shows**:
- Current API usage for the billing period
- Cached for 3 minutes to avoid excessive API calls
- Requires valid API key in Claude Code

## Troubleshooting

### ccline not found

```bash
# Check if installed
npm list -g @cometix/ccline

# Reinstall if needed
npm install -g @cometix/ccline

# Verify binary exists
ls -lh ~/.claude/ccline/ccline
```

### Status bar not showing

```bash
# Check settings.json syntax
cat ~/.claude/settings.json | jq .
# Should parse without errors

# Verify statusLine configuration
cat ~/.claude/settings.json | jq .statusLine
# Should show the statusLine config

# Restart Claude Code
# Status line appears on next session
```

### Icons not displaying (show as boxes/question marks)

**Problem**: Terminal font doesn't support Nerd Font icons

**Solutions**:
1. **Change terminal font** to a Nerd Font:
   - JetBrains Mono Nerd Font (already installed)
   - Configure in Kitty/Konsole settings

2. **Switch to plain mode**:
   ```toml
   # In config.toml
   [style]
   mode = "plain"
   ```

### Config changes not applying

```bash
# Config is read on Claude Code startup
# Restart Claude Code to see changes

# Verify config syntax
cat ~/.claude/ccline/config.toml
# Check for TOML errors
```

### Usage segment shows errors

**Common causes**:
- API key not configured
- Network timeout
- API rate limiting

**Check timeout**:
```toml
# In my-theme.toml, increase timeout
[segments.options]
timeout = 5  # Increase from 2 to 5 seconds
```

## Benefits

### Real-Time Visibility

- **Token Usage**: Monitor context window to avoid compacting
- **Session Time**: Track how long you've been working
- **Git Status**: See branch without running commands
- **Model Awareness**: Know which Claude model you're using

### Customization

- **Themes**: 9+ built-in themes + custom
- **Segments**: Enable/disable as needed
- **Colors**: Full 256-color palette
- **Icons**: Nerd Font or plain text

### Integration

- **Automatic**: Status line updates automatically
- **Non-intrusive**: Minimal padding, clean display
- **Performant**: Cached API calls, fast display

## Command Choice Rationale

**Chosen**: `~/.claude/ccline/ccline` (full path)

**Why not `ccline`?**
- Requires npm global bin in PATH
- Depends on mise PATH configuration
- Less explicit

**Why full path?**
- ✅ Works regardless of PATH
- ✅ Explicit and self-documenting
- ✅ npm install creates binary at this location automatically
- ✅ More reliable across different shell configurations

## Deployment Checklist

For new machine setup:

- [x] Run `make all` (installs ccline via bootstrap)
- [x] Config deployed via stow: `~/.claude/ccline/config.toml`
- [x] Custom theme deployed: `~/.claude/ccline/themes/my-theme.toml`
- [x] Settings configured: `statusLine` in `~/.claude/settings.json`
- [x] Verify: `ccline --version` shows 1.0.8
- [x] Verify: Status line appears in Claude Code

## Testing

### Verify Installation

```bash
# Check ccline version
ccline --version
# Output: ccline 1.0.8

# Check binary location
ls -lh ~/.claude/ccline/ccline
# Should show 8.5MB executable

# Check config exists
cat ~/.claude/ccline/config.toml
# Should show theme = "my-theme"

# Check custom theme exists
cat ~/.claude/ccline/themes/my-theme.toml
# Should show custom configuration
```

### Verify Integration

```bash
# Check settings.json
cat ~/.claude/settings.json | jq .statusLine
# Should show statusLine configuration

# Start Claude Code
claude-code
# Status line should appear at bottom
# Should show: 🤖 model | 📁 dir | 🌿 branch | ⚡ tokens | 📊 usage | ⏱️ time
```

### Test Customization

```bash
# Change theme temporarily
cd ~/.claude/ccline
cp config.toml config.toml.backup
echo 'theme = "gruvbox"' > config.toml

# Restart Claude Code and verify new theme

# Restore original
mv config.toml.backup config.toml
```

## File Locations Reference

| File | Location | Purpose |
|------|----------|---------|
| Binary | `~/.claude/ccline/ccline` | Standalone executable |
| Config | `~/.claude/ccline/config.toml` | Main configuration |
| Custom Theme | `~/.claude/ccline/themes/my-theme.toml` | Your theme |
| Default Themes | `~/.claude/ccline/themes/*.toml` | NPM-installed themes |
| Settings | `~/.claude/settings.json` | Claude Code integration |
| Dotfiles Config | `dotfiles/claude/.claude/ccline/config.toml` | Template |
| Dotfiles Theme | `dotfiles/claude/.claude/ccline/themes/my-theme.toml` | Template |

## NPM Installation Details

**Command**: `npm install -g @cometix/ccline`

**What it does**:
1. Downloads ccline package from npm
2. Creates standalone binary at `~/.claude/ccline/ccline`
3. Installs default themes to `~/.claude/ccline/themes/`
4. Creates symlink in npm global bin (if needed)

**Version**: 1.0.8 (as of 2025-10-19)

**Dependencies**: None (standalone binary)

**Size**: ~8.5MB (binary + themes)

## Updates

### Update ccline

```bash
# Update to latest version
npm update -g @cometix/ccline

# Or reinstall
npm install -g @cometix/ccline --force

# Verify new version
ccline --version
```

**Note**: Updates preserve `config.toml` and custom themes

## Platform Compatibility

- ✅ **CachyOS/Arch Linux**: Primary platform
- ✅ **Linux**: Should work on any Linux with Node/npm
- ✅ **WSL2**: Should work (untested)
- ⚠️ **macOS**: Should work (untested, may need path adjustments)
- ❌ **Windows**: Not tested (WSL2 recommended)

## Credits

- **CCometixLine**: Created by Haleclipse
- **Repository**: https://github.com/Haleclipse/CCometixLine
- **Integration**: Added to CachyOS dotfiles 2025-10-19

---

**Status**: ✅ Complete and ready for deployment
**Documentation**: CLAUDE.md updated with ccline section
**Bootstrap**: Automatically installs ccline on new machines

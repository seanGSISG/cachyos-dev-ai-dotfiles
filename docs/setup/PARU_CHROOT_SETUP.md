# Paru Chroot Configuration

**Date**: 2025-10-19
**Status**: ✅ Complete

## Overview

Configured paru (AUR helper) to use chroot builds by default. This isolates AUR package builds from the mise-managed development environment, preventing conflicts with mise-managed Python/Node versions.

## Problem Solved

### The Issue

When using `mise` to manage Python/Node versions:
- Mise creates shims in `~/.local/share/mise/shims/`
- These shims intercept commands like `python`, `node`, etc.
- During AUR package builds, these shims can cause:
  - Wrong Python/Node version being used
  - "Command not found" errors
  - Build failures due to missing dependencies

### The Solution

Enable chroot builds in paru configuration:
- Builds run in isolated chroot environment
- Uses system Python/Node, not mise-managed versions
- Matches official Arch build system behavior
- Ensures reproducible, clean builds

## Implementation

### Files Created/Modified

1. **New**: `dotfiles/paru/.config/paru/paru.conf`
   - Enables `Chroot = true`
   - Configures `BottomUp` and `CleanAfter`
   - Includes detailed comments

2. **Modified**: `bootstrap.sh`
   - Added `devtools` to base packages (required for chroot)

3. **Modified**: `CLAUDE.md`
   - Documented paru chroot configuration
   - Added troubleshooting section

## Configuration Details

### Paru Config (`~/.config/paru/paru.conf`)

Key settings:
```ini
[options]
Chroot = true        # Use chroot for AUR builds
BottomUp = true      # Show dependencies first
CleanAfter = true    # Clean build dir after install
```

### Requirements

- `devtools` package (installed by bootstrap.sh)
- Paru AUR helper (auto-installed if missing)

### Chroot Setup

The chroot is automatically managed by paru. If needed, manually initialize:
```bash
paru --gendb
```

## Deployment

### Fresh Install

1. Run bootstrap:
   ```bash
   make all
   ```
   - Installs `devtools` package
   - Installs `paru` if missing

2. Deploy dotfiles:
   ```bash
   # Included in bootstrap, but can be run manually:
   cd ~/dev/cachyos-dev-ai-dotfiles
   stow -d dotfiles -t ~ paru
   ```

3. Verify configuration:
   ```bash
   cat ~/.config/paru/paru.conf
   # Should show Chroot = true
   ```

### Existing System

1. Install devtools:
   ```bash
   sudo pacman -S devtools
   ```

2. Deploy paru config:
   ```bash
   cd ~/dev/cachyos-dev-ai-dotfiles
   stow -d dotfiles -t ~ paru
   ```

3. Initialize chroot (optional):
   ```bash
   paru --gendb
   ```

## Usage

### Installing AUR Packages

No changes needed - chroot is automatic:
```bash
# Works as normal, but uses chroot
paru -S package-name

# Chroot is transparent to the user
paru -Syu  # Upgrade all AUR packages
```

### Verifying Chroot is Active

Check if chroot is being used:
```bash
# Look for "Building in chroot" message
paru -S some-aur-package

# Check paru config
grep Chroot ~/.config/paru/paru.conf
# Should show: Chroot = true
```

### Troubleshooting

#### Chroot Build Fails

```bash
# Reinitialize chroot database
paru --gendb

# Or force clean rebuild
paru -S --rebuild package-name
```

#### Want to Disable Chroot

Edit `~/.config/paru/paru.conf`:
```ini
# Change from:
Chroot = true

# To:
#Chroot = true
```

## Benefits

### Isolation from Mise

**Without chroot**:
- AUR build uses mise-managed Python 3.13
- May fail if package expects system Python
- Environment variables from mise affect build

**With chroot**:
- AUR build uses system Python
- Clean environment, no mise interference
- Reproducible builds

### Build Reliability

- Matches official Arch packaging environment
- Consistent builds across different machines
- No user environment pollution

### Development Workflow

- Keep using `mise` for development
- AUR packages build cleanly in isolation
- No need to `mise deactivate` before building

## How Chroot Works

### Build Process

1. User runs: `paru -S package-name`
2. Paru creates temporary chroot at `/var/lib/paru/chroot/`
3. Installs base-devel and dependencies in chroot
4. Builds package inside chroot
5. Extracts built package
6. Installs package on system
7. Cleans up chroot (if `CleanAfter = true`)

### Chroot Structure

```
/var/lib/paru/chroot/
├── root/          # Base system (Arch base-devel)
└── username/      # Build environment
```

### Performance Impact

- **First build**: Slower (creates chroot)
- **Subsequent builds**: Faster (reuses chroot)
- **Storage**: ~1-2GB for chroot environment

## Configuration Reference

### All Paru Chroot Options

Available in `[options]` section:
```ini
# Enable/disable chroot
Chroot = true

# Chroot directory (default shown)
#Chrootdir = /var/lib/paru/chroot

# User for builds in chroot
#BuildUser = paru
```

### Additional Options Enabled

```ini
# Show packages bottom-up (deps first)
BottomUp = true

# Clean build directory after install
CleanAfter = true

# Fetch PGP keys automatically
PgpFetch = true

# Update devel packages (-git, -svn, etc.)
Devel = true
```

## Platform Compatibility

- ✅ **CachyOS/Arch Linux**: Primary platform
- ✅ **Arch-based distros**: Should work
- ✅ **WSL2 Arch**: Should work (untested)
- ❌ **Non-Arch**: Not applicable

## References

- Paru documentation: `man paru.conf`
- Arch devtools: https://wiki.archlinux.org/title/DeveloperWiki:Building_in_a_clean_chroot
- Paru GitHub: https://github.com/Morganamilo/paru

## Testing

### Verify Configuration

```bash
# 1. Check paru config exists
test -f ~/.config/paru/paru.conf && echo "✓ Config exists"

# 2. Check Chroot is enabled
grep "^Chroot" ~/.config/paru/paru.conf
# Should output: Chroot = true

# 3. Check devtools is installed
pacman -Q devtools
# Should show: devtools <version>
```

### Test Chroot Build

```bash
# Install small AUR package to test
paru -S hello

# Look for these messages in output:
# - "Building in chroot"
# - No errors about missing commands
```

### Compare With/Without Chroot

```bash
# Build without chroot (for comparison)
# Temporarily disable in config, then:
paru -S package-name

# Build with chroot (normal)
# Re-enable in config, then:
paru -S package-name

# Chroot build should be cleaner, no mise interference
```

## Migration Notes

### Existing Paru Users

If you already have `~/.config/paru/paru.conf`:

1. **Backup existing config**:
   ```bash
   cp ~/.config/paru/paru.conf ~/.config/paru/paru.conf.backup
   ```

2. **Merge configurations**:
   ```bash
   # View dotfiles version
   cat ~/dev/cachyos-dev-ai-dotfiles/dotfiles/paru/.config/paru/paru.conf

   # Manually merge or replace
   ```

3. **Deploy via stow** (overwrites):
   ```bash
   stow -d ~/dev/cachyos-dev-ai-dotfiles/dotfiles -t ~ paru
   ```

### First-Time Setup

Stow will create `~/.config/paru/` and symlink the config automatically:
```bash
cd ~/dev/cachyos-dev-ai-dotfiles
stow -d dotfiles -t ~ paru
```

## Summary

✅ **What was done**:
1. Created `dotfiles/paru/.config/paru/paru.conf` with chroot enabled
2. Added `devtools` to `bootstrap.sh` package list
3. Documented in `CLAUDE.md`

✅ **Result**:
- Paru uses chroot for all AUR builds by default
- Mise environment isolated from package builds
- Clean, reproducible builds

✅ **Status**: Ready for deployment

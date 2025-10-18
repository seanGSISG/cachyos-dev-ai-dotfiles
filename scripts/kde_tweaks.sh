#!/usr/bin/env bash
set -euo pipefail

# Minimal KDE ricing & keybinds. Safe defaults; idempotent.

echo "==> Applying KDE tweaks..."

# Icons & cursor
kwriteconfig6 --file kdeglobals --group Icons --key Theme Papirus-Dark
kwriteconfig6 --file kcminputrc --group Mouse --key cursorTheme Bibata-Modern-Ice

# Konsole: set default profile "Cachy"
mkdir -p "$HOME/.local/share/konsole"
cp -n "$(dirname "$0")/../dotfiles/konsole-profile/.local/share/konsole/Cachy.profile" "$HOME/.local/share/konsole/Cachy.profile" || true
kwriteconfig6 --file konsolerc --group 'Desktop Entry' --key DefaultProfile Cachy.profile

# KWin quick-tiles (H/J/K/L on Meta)
kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Quick Tile Window to the Left" "Meta+H,none,Quick Tile Window to the Left"
kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Quick Tile Window to the Right" "Meta+L,none,Quick Tile Window to the Right"
kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Quick Tile Window to the Top" "Meta+K,none,Quick Tile Window to the Top"
kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Quick Tile Window to the Bottom" "Meta+J,none,Quick Tile Window to the Bottom"

# Reduce animation duration a bit for snappier feel
kwriteconfig6 --file kwinrc --group Compositing --key AnimationSpeed 3

# Apply Global Theme if Catppuccin is available
if lookandfeeltool --list | grep -qi catppuccin; then
  echo "Applying Catppuccin-Mocha global theme..."
  lookandfeeltool --apply catppuccin-mocha || true
fi

# Reload KWin & Plasma configs
echo "Reloading Plasma shell and KWin..."
qdbus org.kde.KWin /KWin reconfigure || true
qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.reloadConfig || true

echo "✅ KDE tweaks applied. You may need to log out/in for some settings."

#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Removing config symlinks..."

STOW_PACKAGES=(zsh tmux starship ghostty yabai skhd sketchybar borders karabiner nvim lazygit btop nnn)
for pkg in "${STOW_PACKAGES[@]}"; do
    if stow -d "$SCRIPT_DIR/home" -t "$HOME" -D "$pkg" 2>/dev/null; then
        echo "  ✓ $pkg"
    else
        echo "  - $pkg (not linked, skipping)"
    fi
done

echo ""
echo "Symlinks removed. Your \$HOME no longer points to setup/."
echo ""
echo "If you have old configs to restore:"
echo "  tar -xzf ~/config-backup-*.tar.gz -C /"
echo ""
echo "Then reload:"
echo "  source ~/.zshrc"
echo "  tmux kill-server && tmux"
echo "  brew services restart sketchybar"
echo "  Open Karabiner-Elements.app → reload"

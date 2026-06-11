#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "==> Checking Homebrew..."
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "==> Installing dependencies..."
brew bundle --file="$SCRIPT_DIR/Brewfile"

echo "==> Checking stow..."
if ! command -v stow &>/dev/null; then
    brew install stow
fi

echo "==> Symlinking configs..."
STOW_ARGS=(-d "$SCRIPT_DIR/home" -t "$HOME")
if [ "${1:-}" = "--adopt" ]; then
    STOW_ARGS+=("--adopt")
    echo "  (adopt mode: existing files will be moved into repo)"
fi

STOW_PACKAGES=(zsh tmux starship ghostty yabai skhd sketchybar borders karabiner nvim lazygit btop nnn)
for pkg in "${STOW_PACKAGES[@]}"; do
    if stow "${STOW_ARGS[@]}" "$pkg" 2>/tmp/stow-err; then
        echo "  ✓ $pkg"
    else
        echo "  ✗ $pkg: $(cat /tmp/stow-err)"
    fi
done

echo "==> Generating derived configs..."
bash "$SCRIPT_DIR/home/shared/generate-colors.sh"

echo "==> Building sketchybar helpers..."
make -C "$SCRIPT_DIR/home/sketchybar/.config/sketchybar/helpers"

echo "==> Building karabiner config..."
(cd "$SCRIPT_DIR/home/karabiner/.config/karabiner" && npm install && npm run build)

echo "==> Installing fast_open..."
sh "$SCRIPT_DIR/tools/fast_open/install.sh"

echo "==> Applying macOS defaults..."
sh "$SCRIPT_DIR/scripts/macos-defaults.sh"

echo "==> Starting services..."
start_svc() {
    local bin="$1"
    local name="${2:-$bin}"
    if command -v "$bin" &>/dev/null; then
        if pgrep -x "$name" >/dev/null 2>&1; then
            echo "  ✓ $name (already running)"
        else
            if "$bin" --start-service 2>/dev/null; then
                echo "  ✓ $name started"
            else
                echo "  ✗ $name failed to start"
            fi
        fi
    else
        echo "  ! $name not found, skipping"
    fi
}
start_svc yabai
start_svc skhd
start_svc sketchybar
brew services restart borders 2>/dev/null && echo "  ✓ borders started" || echo "  ✗ borders failed to start"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Setup complete"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "All configs are now symlinked from setup/home/ into \$HOME."
echo ""

# Count results
sym_ok=0
sym_missing=0
for label in "zsh:.zshrc" "tmux:.config/tmux/tmux.conf" "yabai:.config/yabai" "skhd:.config/skhd" "sketchybar:.config/sketchybar" "borders:.config/borders" "karabiner:.config/karabiner" "ghostty:.config/ghostty/config.ghostty" "starship:.config/starship.toml" "nvim:.config/nvim" "lazygit:.config/lazygit" "btop:.config/btop" "nnn:.config/nnn"; do
    path="${label##*:}"
    if [ -L "$HOME/$path" ]; then
        sym_ok=$((sym_ok + 1))
    elif [ -e "$HOME/$path" ]; then
        sym_missing=$((sym_missing + 1))
        echo "  ! $HOME/$path is a real file (not a symlink)"
    fi
done

if [ $sym_missing -gt 0 ]; then
    echo ""
    echo "  $sym_missing files need attention. Remove them and re-run to fix:"
    echo "    rm -rf the paths above"
else
    echo "✓  All configs symlinked"
fi

# Service status
echo ""
echo "Services:"
check_svc() { pgrep -x "$1" >/dev/null && echo "  ● $1 is running" || echo "  ○ $1 is not running — start with: brew services start $1"; }
check_svc yabai
check_svc skhd
check_svc sketchybar

echo ""
echo "To start using the new configs:"
echo "  1. Source zsh:     source ~/.zshrc"
echo "  2. Reload tmux:    tmux source-file ~/.config/tmux/tmux.conf"
echo "  3. Restart sketchybar if needed: brew services restart sketchybar"
echo "  4. Open Karabiner-Elements.app → 'Complex Modifications' → reload"
echo ""

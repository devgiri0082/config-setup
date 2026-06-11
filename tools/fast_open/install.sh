#!/usr/bin/env bash

# Exit on error
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Target paths
CONFIG_DIR="$HOME/.config/fast_open"
SCRIPT_DEST="$CONFIG_DIR/fast_open"
DEFAULT_JSON="$CONFIG_DIR/config.json"

echo "Installing fast_open..."

# Create config directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

# Copy fast_open script to ~/.config/fast_open/fast_open
cp "$SCRIPT_DIR/fast_open" "$SCRIPT_DEST"
chmod +x "$SCRIPT_DEST"
echo "✓ Installed script to $SCRIPT_DEST"

# Create default config.json if it doesn't exist
if [ ! -f "$DEFAULT_JSON" ]; then
    cat <<EOF > "$DEFAULT_JSON"
{
  "w1_pane1": "",
  "w2_pane1": "",
  "w2_pane2": "",
  "w2_pane3": "",
  "w2_pane4": "",
  "_info": "Specify commands to run on startup. Example: 'w1_pane1': 'nvim .', 'w2_pane1': 'agy'"
}
EOF
    echo "✓ Created default global config at $DEFAULT_JSON"
else
    echo "✓ Global config already exists at $DEFAULT_JSON"
fi

# Try to symlink to /usr/local/bin/fo
SYMLINK_DEST="/usr/local/bin/fo"
INSTALL_METHOD=""

if [ -w "/usr/local/bin" ]; then
    ln -sf "$SCRIPT_DEST" "$SYMLINK_DEST"
    echo "✓ Created symlink at $SYMLINK_DEST"
    INSTALL_METHOD="symlink"
else
    # Try ~/.local/bin/fo if it exists and is in PATH
    USER_BIN_DIR="$HOME/.local/bin"
    if [[ ":$PATH:" == *":$USER_BIN_DIR:"* ]]; then
        mkdir -p "$USER_BIN_DIR"
        ln -sf "$SCRIPT_DEST" "$USER_BIN_DIR/fo"
        echo "✓ Created symlink at $USER_BIN_DIR/fo"
        INSTALL_METHOD="local_symlink"
    fi
fi

# Fallback: Add alias to shell configurations if symlink wasn't created
if [ -z "$INSTALL_METHOD" ]; then
    ALIAS_CMD="alias fo=\"$SCRIPT_DEST\""
    SHELL_CONFIGS=("$HOME/.zshrc" "$HOME/.bashrc")
    UPDATED_ANY=false

    for conf in "${SHELL_CONFIGS[@]}"; do
        if [ -f "$conf" ]; then
            if ! grep -q "alias fo=" "$conf"; then
                echo "" >> "$conf"
                echo "# fast_open alias" >> "$conf"
                echo "$ALIAS_CMD" >> "$conf"
                echo "✓ Added alias 'fo' to $conf"
                UPDATED_ANY=true
            else
                echo "✓ Alias 'fo' already exists in $conf"
                UPDATED_ANY=true
            fi
        fi
    done

    if [ "$UPDATED_ANY" = true ]; then
        echo "Please restart your terminal or run: source ~/.zshrc (or ~/.bashrc) to enable 'fo'."
    else
        echo "No standard shell config files (~/.zshrc or ~/.bashrc) found."
        echo "Please add the following alias manually to your shell configuration:"
        echo "  $ALIAS_CMD"
    fi
else
    echo "Success! You can now run 'fo <directory>' in any new terminal window."
fi

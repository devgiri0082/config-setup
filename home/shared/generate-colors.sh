#!/usr/bin/env bash
# Generates .zshrc color exports and sketchybar colors.lua from shared/colors.conf
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
SHARED="$REPO_DIR/home/shared/colors.conf"
ZSH_COLORS_START="# --- Color Scheme (generated from shared/colors.conf) ---"
ZSH_COLORS_END="# --- End Color Scheme ---"

generate_zsh() {
  local output="$REPO_DIR/home/zsh/.zshrc"
  local in_block=false
  local tmp=$(mktemp)

  while IFS= read -r line; do
    if [[ "$line" == "$ZSH_COLORS_START" ]]; then
      in_block=true
      echo "$line" >> "$tmp"
      while IFS='=' read -r name value; do
        [[ -z "$name" || "$name" =~ ^# ]] && continue
        [[ "$name" =~ ^(BAR_|POPUP_) ]] && continue
        printf 'export %s=%s\n' "$name" "$value" >> "$tmp"
      done < "$SHARED"
      continue
    fi
    if $in_block; then
      if [[ "$line" == "$ZSH_COLORS_END" ]]; then
        in_block=false
        echo "$line" >> "$tmp"
      fi
      continue
    fi
    echo "$line" >> "$tmp"
  done < "$output"
  mv "$tmp" "$output"
}

generate_lua() {
  local output="$REPO_DIR/home/sketchybar/.config/sketchybar/colors.lua"
  local tmp=$(mktemp)

  echo '-- Color Scheme (generated from shared/colors.conf)' > "$tmp"
  echo 'return {' >> "$tmp"

  while IFS='=' read -r name value; do
    [[ -z "$name" || "$name" =~ ^# ]] && continue
    [[ "$name" =~ ^(BAR_|POPUP_) ]] && continue
    lua_name=$(echo "$name" | tr '[:upper:]' '[:lower:]')
    printf '  %s = %s,\n' "$lua_name" "$value" >> "$tmp"
  done < "$SHARED"

  cat >> "$tmp" << 'BAR'
  bar = {
BAR
  while IFS='=' read -r name value; do
    [[ "$name" == "BAR_BG" ]] && printf '    bg = %s,\n' "$value" >> "$tmp"
    [[ "$name" == "BAR_BORDER" ]] && printf '    border = %s,\n' "$value" >> "$tmp"
  done < "$SHARED"
  echo '  },' >> "$tmp"

  cat >> "$tmp" << 'POPUP'
  popup = {
POPUP
  while IFS='=' read -r name value; do
    [[ "$name" == "POPUP_BG" ]] && printf '    bg = %s,\n' "$value" >> "$tmp"
    [[ "$name" == "POPUP_BORDER" ]] && printf '    border = %s,\n' "$value" >> "$tmp"
  done < "$SHARED"
  echo '  },' >> "$tmp"

  cat >> "$tmp" << 'TAIL'
  bg1 = 0xff363944,
  bg2 = 0xff414550,

  with_alpha = function(color, alpha)
    if alpha > 1.0 or alpha < 0.0 then return color end
    return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
  end,
}
TAIL

  mv "$tmp" "$output"
}

echo "Generating color consumers from $SHARED"
generate_zsh
generate_lua
echo "Done. Updated .zshrc exports and sketchybar colors.lua"

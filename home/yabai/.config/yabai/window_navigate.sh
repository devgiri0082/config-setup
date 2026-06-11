#!/bin/bash

# Usage: window_navigate.sh <direction>
# Directions: west, south, north, east

DIR=$1

case $DIR in
  west)  TMUX_DIR="L"; YABAI_DIR="west";  TMUX_EDGE_DIR="left" ;;
  south) TMUX_DIR="D"; YABAI_DIR="south"; TMUX_EDGE_DIR="bottom" ;;
  north) TMUX_DIR="U"; YABAI_DIR="north"; TMUX_EDGE_DIR="top" ;;
  east)  TMUX_DIR="R"; YABAI_DIR="east";  TMUX_EDGE_DIR="right" ;;
esac

# Check if the active window is a terminal
ACTIVE_APP=$(yabai -m query --windows --window | jq -r '.app')

if [[ "$ACTIVE_APP" == "Ghostty" || "$ACTIVE_APP" == "kitty" || "$ACTIVE_APP" == "Alacritty" || "$ACTIVE_APP" == "iTerm2" || "$ACTIVE_APP" == "Terminal" ]]; then
  # We are in a terminal. Check if tmux is running and active
  if tmux info &>/dev/null; then
    # Check if the active pane is at the edge of the direction
    IS_AT_EDGE=$(tmux display-message -p "#{pane_at_${TMUX_EDGE_DIR}}" 2>/dev/null)
    
    if [ "$IS_AT_EDGE" = "0" ]; then
      # Not at the edge, let tmux navigate
      tmux select-pane -"${TMUX_DIR}"
      exit 0
    fi
  fi
fi

# Fallback: Let yabai navigate OS windows
CURRENT_ZOOM=$(yabai -m query --windows --window 2>/dev/null | jq -r 'if .["has-fullscreen-zoom"] then "fullscreen" elif .["has-parent-zoom"] then "parent" else "none" end' 2>/dev/null)

# Find target window in direct direction
TARGET_ID=$(yabai -m query --windows --window "${YABAI_DIR}" 2>/dev/null | jq -r '.id' 2>/dev/null)

# If no target window in that direction, wrap around within the current space!
if [ -z "$TARGET_ID" ] || [ "$TARGET_ID" = "null" ]; then
  CURRENT_WINDOW_JSON=$(yabai -m query --windows --window 2>/dev/null)
  CURRENT_ID=$(echo "$CURRENT_WINDOW_JSON" | jq -r '.id' 2>/dev/null)
  CURRENT_X=$(echo "$CURRENT_WINDOW_JSON" | jq -r '.frame.x' 2>/dev/null)
  CURRENT_Y=$(echo "$CURRENT_WINDOW_JSON" | jq -r '.frame.y' 2>/dev/null)
  
  if [ -n "$CURRENT_ID" ] && [ "$CURRENT_ID" != "null" ]; then
    case $DIR in
      west)
        TARGET_ID=$(yabai -m query --windows --space 2>/dev/null | jq --argjson current_id "$CURRENT_ID" --argjson current_y "$CURRENT_Y" -r '
          def abs: if . < 0 then -. else . end;
          map(select(.["is-visible"] and .["is-minimized"] == false and .id != $current_id))
          | sort_by([.frame.x, -((.frame.y - $current_y) | abs)])
          | last
          | .id
        ' 2>/dev/null)
        ;;
      east)
        TARGET_ID=$(yabai -m query --windows --space 2>/dev/null | jq --argjson current_id "$CURRENT_ID" --argjson current_y "$CURRENT_Y" -r '
          def abs: if . < 0 then -. else . end;
          map(select(.["is-visible"] and .["is-minimized"] == false and .id != $current_id))
          | sort_by([.frame.x, ((.frame.y - $current_y) | abs)])
          | first
          | .id
        ' 2>/dev/null)
        ;;
      north)
        TARGET_ID=$(yabai -m query --windows --space 2>/dev/null | jq --argjson current_id "$CURRENT_ID" --argjson current_x "$CURRENT_X" -r '
          def abs: if . < 0 then -. else . end;
          map(select(.["is-visible"] and .["is-minimized"] == false and .id != $current_id))
          | sort_by([.frame.y, -((.frame.x - $current_x) | abs)])
          | last
          | .id
        ' 2>/dev/null)
        ;;
      south)
        TARGET_ID=$(yabai -m query --windows --space 2>/dev/null | jq --argjson current_id "$CURRENT_ID" --argjson current_x "$CURRENT_X" -r '
          def abs: if . < 0 then -. else . end;
          map(select(.["is-visible"] and .["is-minimized"] == false and .id != $current_id))
          | sort_by([.frame.y, ((.frame.x - $current_x) | abs)])
          | first
          | .id
        ' 2>/dev/null)
        ;;
    esac
  fi
fi

# Focus the target window
if [ -n "$TARGET_ID" ] && [ "$TARGET_ID" != "null" ]; then
  if [ "$CURRENT_ZOOM" != "none" ] && [ -n "$CURRENT_ZOOM" ]; then
    yabai -m window --toggle zoom-"${CURRENT_ZOOM}"
    yabai -m window --focus "${TARGET_ID}"
    yabai -m window "${TARGET_ID}" --toggle zoom-"${CURRENT_ZOOM}"
  else
    yabai -m window --focus "${TARGET_ID}"
  fi
else
  # Default fallback (display navigation or no-op)
  yabai -m display --focus "${YABAI_DIR}" || true
fi

# Keybindings

Master reference for all keyboard shortcuts across layers.

## Modifier legend

| Label | Keys pressed |
|-------|-------------|
| `⌃` | Control |
| `⌥` | Option (Alt) |
| `⇧` | Shift |
| `⌘` | Command |
| `lalt` | Left Option |
| `Hyper` | Caps Lock (acts as ⌃⌥⇧⌘) |

## Layer separation (no collisions)

- **Karabiner** operates at OS level — remaps keys before any app sees them. Uses Hyper (`⌃⌥⇧⌘` via Caps Lock).
- **skhd** captures `lalt` combos — controls yabai window manager.
- **tmux** captures `Alt` (Option) combos inside terminal — controls panes/windows. Single config: `~/.config/tmux/tmux.conf`.

Since Karabiner uses Hyper (all four mods), skhd uses `lalt` specifically, and tmux uses `Alt` only inside the terminal, there are no collisions.

---

## Karabiner (Hyper Key = Caps Lock)

Caps Lock alone → Escape. Caps Lock held → Hyper.

### Hyper + number — launch apps

| Key | App |
|-----|-----|
| `0` | Ghostty |
| `9` | Google Chrome |
| `8` | Zed |
| `7` | Notion |
| `6` | Clockify |

### Hyper + o — open applications

| Key | App |
|-----|-----|
| `g` | Google Chrome |
| `e` | Microsoft Edge |
| `c` | Cursor |
| `n` | Notion |
| `d` | Discord |
| `s` | Slack |
| `t` | Ghostty |
| `m` | Mail |
| `f` | Finder |
| `i` | Insomnia |
| `w` | WhatsApp |

### Hyper + v — cursor movement

| Key | Action |
|-----|--------|
| `h` / `j` / `k` / `l` | Arrow keys |
| `u` | Page down |
| `i` | Page up |
| `s` | Scroll mode |
| `m` | Magic move |

### Hyper + s — system controls

| Key | Action |
|-----|--------|
| `u` / `j` | Volume up / down |
| `i` / `k` | Brightness up / down |
| `p` | Play / pause |
| `l` | Lock screen |

### Hyper + r — Raycast

| Key | Action |
|-----|--------|
| `a` | AI chat |
| `c` | Color picker |
| `e` | Emoji picker |
| `h` | Clipboard history |
| `p` | Confetti |
| `s` | Silent mention |

### Hyper + b — browse

Launches browser to various sites (YouTube, Facebook, Reddit, Spotify, Trello, Vercel).

### App-specific

| App | Shortcut | Action |
|-----|----------|--------|
| VSCode / Cursor / Zed | `Ctrl+Y` | Enter |

---

## skhd (yabai window manager)

All use left Option (`lalt`) as modifier.

### Navigation

| Shortcut | Action |
|----------|--------|
| `lalt + 1-4` | Focus space |
| `lalt + hjkl` | Navigate windows (via window_navigate.sh — tmux-aware) |
| `lalt + space` | Toggle float |
| `lalt + f` | Zoom to parent |
| `lalt + a` | Focus first window |
| `lalt + '` | Focus last window |

### Window movement

| Shortcut | Action |
|----------|--------|
| `⇧lalt + hjkl` | Warp window between spaces/displays, or pixel-move 10px |
| `⇧lalt + 1-4` | Move window to space |
| `⇧lalt + p/n` | Move window to prev/next space |
| `⇧lalt + s` | Toggle split orientation |
| `⇧lalt + x/y` | Mirror space on axis |
| `⇧lalt + f` | Toggle space-wide fullscreen mode (stack layout, all windows fill space) |

### Stacks

| Shortcut | Action |
|----------|--------|
| `⇧⌃ + hjkl` | Stack window in direction |
| `⇧⌃ + n/p` | Next/prev in stack |

In space-wide fullscreen mode (`⇧lalt + f`), all windows in the space share one frame and behave like a stack — use `⇧⌃ + n/p` to cycle between them.

### Resize

| Shortcut | Action |
|----------|--------|
| `⌃lalt + hjkl` | Resize window ±100px |
| `⌃lalt + e` | Balance space |
| `⌃lalt + g` | Toggle gaps |

### Insertion

| Shortcut | Action |
|----------|--------|
| `lalt + s` | Insert east + new terminal |
| `lalt + v` | Insert south + new terminal |
| `⇧⌃lalt + hjkl` | Set insertion point |

### Misc

| Shortcut | Action |
|----------|--------|
| `⇧lalt + space` | Toggle sketchybar visibility |

---

## tmux

Config: `~/.config/tmux/tmux.conf` (single file, no more dual-config confusion). Prefix is `C-Space`.

### Without prefix (active immediately in terminal)

| Shortcut | Action |
|----------|--------|
| `Alt + arrows` | Switch pane (arrow keys) |
| `Alt + hjkl` | Switch pane (vim keys) |
| `Alt + ⇧HJKL` | Swap pane in direction |
| `Alt + 0-9` | Switch workspace (0 = workspace 10, auto-creates if missing) |
| `Alt + ⇧0-9` | Move pane to workspace (0 = workspace 10, ⇧0 = `)`, ⇧1 = `!`, etc.) |
| `Alt + o` | Next pane |
| `Alt + ⇧o` | Swap pane down |
| `Alt + n` | Smart split (horizontal or vertical) |
| `Alt + w` | Kill pane |
| `Alt + enter` | Rename window |
| `Alt + ⇧e` | Detach session |
| `Alt + s` | Layout: main-horizontal |
| `Alt + S` | Layout: even-vertical |
| `Alt + v` | Layout: main-vertical |
| `Alt + V` | Layout: even-horizontal |
| `Alt + t` | Layout: tiled |
| `Alt + z` | Zoom pane |
| `Alt + r` | Refresh layout |

### With prefix (`C-Space` then...)

| Keys | Action |
|------|--------|
| `\` | Split horizontal |
| `-` | Split vertical |
| `C-Space` | Send prefix to nested session |

---

## Key collision notes

- **`Alt + hjkl` in tmux vs `lalt+hjkl` in skhd** — No collision. tmux only captures these when inside a terminal window. skhd's `lalt` is the physical left Option key specifically. When inside Ghostty/tmux, `lalt+hjkl` navigates tmux panes (via `window_navigate.sh`'s tmux-aware logic) instead of yabai windows.

- **`Alt + w` in tmux vs Hyper + `w` in Karabiner** — Different modifiers. Karabiner's Hyper is `⌃⌥⇧⌘` (all four), tmux uses just `Alt`.

- **`Alt + 1-4` in tmux vs `lalt + 1-4` in skhd** — skhd fires at OS level, tmux only inside terminal. `window_navigate.sh` handles the handoff when inside Ghostty.

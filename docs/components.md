# Components

How each piece fits together in this setup.

## Layers (bottom to top)

### Keyboard — Karabiner-Elements
Rewrites keys at the OS level. Caps Lock acts as Hyper Key (⌃⌥⇧⌘) when held, Escape when tapped. App-specific rules remap keys (e.g. Ctrl+Y → Enter in editors).

Config: `home/karabiner/.config/karabiner/` — TypeScript source (`rules.ts`) compiled to `karabiner.json` during install.

### Window manager — yabai + skhd + borders
- **yabai**: BSP tiling. Windows snap to a binary-space-partition layout. No mouse needed — all keyboard driven.
- **skhd**: Hotkey daemon. `lalt+hjkl` navigates windows. `lalt+1-4` switches spaces. `shift+lalt` moves windows. `ctrl+lalt` resizes.
- **borders**: Thin colored borders around yabai windows. Active window gets a brighter border; inactive windows dim.

Config: `home/yabai/.config/yabai/`, `home/skhd/.config/skhd/`, `home/borders/.config/borders/`

### Status bar — sketchybar
Replaces macOS menu bar. Written in Lua with C helpers for CPU/network monitoring and menu bar integration.

Widgets: Apple logo (with app menu), spaces indicator, front app name, media (now playing), calendar/clock, CPU graph, RAM graph, disk usage, WiFi rates, battery %, volume slider.

Config: `home/sketchybar/.config/sketchybar/` — C helpers compiled via `make` during install.

### Terminal — Ghostty + tmux + starship
- **Ghostty**: GPU-accelerated terminal. Broadcast theme, JetBrainsMono font, transparent/blur, left-option-as-alt.
- **tmux**: Single config at `~/.config/tmux/tmux.conf`. C-Space prefix. Alt+hjkl pane nav, Alt+1-9 workspace switching, Alt+n smart split, Alt+s/v/t layouts, pane dimming.
- **starship**: Shell prompt — minimal, shows git status, directory, and custom mode indicators.

Config: `home/ghostty/.config/ghostty/`, `home/tmux/.config/tmux/tmux.conf`, `home/starship/.config/starship.toml`

### Shell — zsh
PATH setup, NVM, plugins (fast-syntax-highlighting, autosuggestions), aliases (lazygit, nnn, fast_open), zoxide integration, Sonokai color exports.

Config: `home/zsh/.zshrc`

### Editor — Neovim (kickstart.nvim)
Lazy-loaded plugin setup based on kickstart.nvim. Custom plugins: cmp, lazygit integration.

Config: `home/nvim/.config/nvim/`

### Dev tools
- **lazygit** — terminal git UI
- **btop** — system resource monitor
- **nnn** — terminal file manager, aliased to `n` with auto-cd on exit
- **fast_open** — tmux project launcher (`fo` command)
- **zoxide** — smart directory jumper (`z` command)
- **ripgrep / fd / bat / fzf / git-delta** — shell utilities

Config: `home/lazygit/.config/lazygit/`, `home/btop/.config/btop/`, `home/nnn/.config/nnn/`

## Dependencies between components

```
karabiner ───────────────────────┐
skhd ──────► yabai ◄── borders   │  OS-level
sketchybar (above yabai bar)     │
                                  │
ghostty ─► tmux ─► starship ─► zsh  Terminal layer
                 ├─ fast_open (tmux sessions)
                 ├─ nvim
                 ├─ lazygit
                 ├─ btop
                 └─ nnn
```

- yabai is the foundation — skhd controls it, borders decorates it, sketchybar sits above it
- tmux launches inside ghostty, starship runs in each tmux pane, zsh is the default shell
- fast_open creates tmux sessions (depends on tmux + zoxide)
- nvim/lazygit/btop/nnn run inside tmux panes (or directly in ghostty)

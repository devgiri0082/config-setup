# setup

Single-command macOS developer environment bootstrap. Clone and run `install.sh` to symlink all configurations, install dependencies, and start services.

## What's included

| Layer | Tools |
|-------|-------|
| Keyboard | karabiner-elements (Hyper Key, app launchers, Raycast shortcuts) |
| Shell | zsh + starship prompt |
| Terminal | ghostty + tmux |
| Window management | yabai + skhd + borders |
| Status bar | sketchybar (Lua + C helpers) |
| Editor | neovim (kickstart.nvim) |
| Dev tools | lazygit, btop, nnn, fast_open |
| Utilities | zoxide, ripgrep, fd, bat, jq, fzf, git-delta |

## Install

```bash
git clone git@github.com:your-username/setup.git ~/.setup
cd ~/.setup
./install.sh
```

## Structure

```
setup/
├── Brewfile                # all Homebrew dependencies
├── install.sh              # single bootstrap script
├── README.md
│
├── home/                   # stow packages ($HOME mirror)
│   ├── zsh/.zshrc
│   ├── tmux/.config/tmux/tmux.conf
│   ├── starship/.config/starship.toml
│   ├── ghostty/.config/ghostty/
│   ├── yabai/.config/yabai/
│   ├── skhd/.config/skhd/
│   ├── sketchybar/.config/sketchybar/
│   ├── borders/.config/borders/
│   ├── karabiner/.config/karabiner/
│   ├── nvim/.config/nvim/
│   ├── lazygit/.config/lazygit/
│   ├── btop/.config/btop/
│   └── nnn/.config/nnn/
│
├── tools/
│   └── fast_open/          # tmux project launcher
│
├── scripts/
│   └── macos-defaults.sh   # system preferences
│
└── docs/
    ├── components.md        # what each piece does
    └── keybindings.md       # master keybinding reference
```

## How it works

`install.sh` runs through these steps:

1. Install Homebrew if missing
2. `brew bundle` to install all packages from Brewfile
3. `stow` each package from `home/` into `$HOME` — creates symlinks
4. Build sketchybar C helpers (`make`)
5. Build karabiner config (`npm install && npm run build`)
6. Install fast_open tool
7. Apply macOS system defaults
8. Start yabai, skhd, sketchybar, borders services

Each config is a separate stow package — you can install them individually: `stow -d home -t ~ yabai` without touching anything else.

## Docs

- [components.md](docs/components.md) — what each piece does and how they connect
- [keybindings.md](docs/keybindings.md) — master keybinding reference across all layers

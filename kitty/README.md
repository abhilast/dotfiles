# Kitty Configuration

## Overview
Kitty is configured under `kitty/.config/kitty/` and stowed to `~/.config/kitty`.

The checked-in setup is centered on:
- `kitty.conf` as the main config
- `macos-shortcuts.conf` for keymaps
- local theme includes like `gruvbox_dark.conf` and `dracula.conf`

## Install
```bash
cd ~/dotfiles
stow kitty
```

## Files In This Repo
- `kitty/.config/kitty/kitty.conf`
- `kitty/.config/kitty/macos-shortcuts.conf`
- `kitty/.config/kitty/reading-optimizations.conf`
- `kitty/.config/kitty/gruvbox_dark.conf`
- `kitty/.config/kitty/dracula.conf`
- `kitty/.config/kitty/diff.conf`

## Current Includes (from `kitty.conf`)
- `include gruvbox_dark.conf`
- `include macos-shortcuts.conf`

## Notable Defaults
- Font: JetBrains Mono Nerd Font Mono (`font_size 16.0`)
- Layouts enabled: `splits,stack,tall,fat,horizontal,vertical,grid`
- Default layout: `splits`
- Scrollback: `scrollback_lines 10000`
- Input/repaint tuning: `input_delay 2`, `repaint_delay 8`, `sync_to_monitor yes`

## Key Shortcuts
See `macos-shortcuts.conf` for the full mapping set. Common ones:
- `Cmd+T` new tab
- `Cmd+D` vertical split
- `Cmd+Shift+D` horizontal split
- `Cmd+Shift+R` reload config
- `Cmd+Enter` fullscreen

## Notes
- Some shell helper aliases/functions reference theme files like `~/.config/kitty/themes/...` and `current-theme.conf`; those files are not tracked in this package.
- For repo-driven behavior, use the files listed above as source of truth.

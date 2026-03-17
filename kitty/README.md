# Kitty Configuration

## Overview
Kitty is configured under `kitty/.config/kitty/` and stowed to `~/.config/kitty`.

The setup is optimized for **Claude Code** usage with:
- Minimal, clean `kitty.conf` (no default comments)
- **Automatic system theme matching** — Nord (dark) + GitHub Light (light)
- macOS keyboard shortcuts in a separate include
- Font and rendering tuned for readability on Retina displays

## Install
```bash
cd ~/dotfiles
stow kitty
```

## Files

| File | Purpose |
|------|---------|
| `kitty.conf` | Main config — fonts, performance, window, scrollback, etc. |
| `macos-shortcuts.conf` | All keyboard shortcuts (tabs, splits, navigation, search) |
| `dark-theme.auto.conf` | Nord theme — auto-loaded in dark mode |
| `light-theme.auto.conf` | GitHub Light theme — auto-loaded in light mode |
| `no-preference-theme.auto.conf` | Fallback theme (Nord) when OS has no preference |
| `diff.conf` | Diff kitten configuration |
| `dracula.conf` | Dracula theme (reference) |
| `gruvbox_dark.conf` | Gruvbox Dark theme (reference) |

## Theme Switching
Kitty automatically switches between Nord and GitHub Light based on macOS appearance. The `*.auto.conf` files are loaded by kitty's built-in OS theme detection — no scripts needed.

To change themes, edit the corresponding `*-theme.auto.conf` file. Orange pane borders (`#ff8800`) are set in all theme files to persist across switches.

## Current Includes (from `kitty.conf`)
- `include macos-shortcuts.conf`

## Notable Settings
- **Font**: JetBrains Mono Nerd Font Mono, size `15`, with `+zero` and `+cv14` features
- **Text rendering**: `text_composition_strategy 1.5 25` (balanced thickness for mild astigmatism)
- **Line spacing**: `cell_height 125%`, `cell_width 101%`
- **Layouts**: `splits,stack,tall,fat,horizontal,vertical,grid` (default: `splits`)
- **Scrollback**: `50000` lines with pixel-smooth scrolling
- **Performance**: `input_delay 2`, `repaint_delay 8`, `sync_to_monitor yes`
- **Remote control**: Enabled via unix socket (`allow_remote_control socket-only`)
- **Pane borders**: 1pt orange (`#ff8800`) with inactive pane dimming (`inactive_text_alpha 0.6`)

## Key Shortcuts
See `macos-shortcuts.conf` for the full mapping set. Common ones:

| Shortcut | Action |
|----------|--------|
| `Cmd+T` | New tab |
| `Cmd+D` | Vertical split |
| `Cmd+Shift+D` | Horizontal split |
| `Cmd+Shift+R` | Reload config |
| `Ctrl+Shift+R` | Reload config (non-macOS) |
| `Cmd+Enter` | Toggle fullscreen |
| `Cmd+Shift+Z` | Toggle stack layout (zoom pane) |
| `Cmd+F` | Fuzzy search scrollback (fzf) |
| `Cmd+1-9` | Jump to tab |
| `Cmd+Option+arrows` | Navigate between splits |

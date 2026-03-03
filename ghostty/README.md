# Ghostty Configuration

## Overview
Ghostty config is tracked in:
- `ghostty/.config/ghostty/config`
- `ghostty/.config/ghostty/profiles.conf`
- `ghostty/.config/ghostty/themes.conf`
- `ghostty/.config/ghostty/shaders/`

## Install
```bash
cd ~/dotfiles
stow ghostty
```

## Current Defaults
From `config`:
- Theme: `light:Builtin Light,dark:Nord`
- Scrollback: `scrollback-limit = 50000`
- Clipboard: `copy-on-select = clipboard`
- Shader: `custom-shader = shaders/cursor_warp.glsl`
- Font: `JetBrainsMono Nerd Font Mono`, size `15`

## Keybinds In Config
- `Cmd+T` new tab
- `Cmd+W` close surface
- `Cmd+N` new window
- `Cmd+D` split right
- `Cmd+Shift+D` split down
- `Cmd+C` copy
- `Cmd+V` paste
- `Ctrl+Shift+R` reload config

## Optional Theme Helpers
Shell functions/aliases in zsh also expose:
- `ghostty-theme`
- `ghostty-auto-theme`
- `ghostty-sync-system`
- `gt`, `gta`, `gts`

These helpers edit `~/.config/ghostty/config`.

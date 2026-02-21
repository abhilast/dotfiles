# Ghostty Configuration

Practical Ghostty setup focused on readability and fast interaction for coding.

## Files

- `ghostty/.config/ghostty/config` - main configuration
- `ghostty/.config/ghostty/profiles.conf` - profile ideas/templates
- `ghostty/.config/ghostty/themes.conf` - theme notes
- `ghostty/.config/ghostty/shaders/` - custom shader files

## Install

```bash
cd ~/dotfiles
stow ghostty
```

Config is then available at `~/.config/ghostty/config`.

## Current Defaults (Important)

- Theme: `light:Builtin Light,dark:Nord`
- Readability tweaks:
  - custom cyan palette overrides for better contrast on light mode
  - larger cell height/width adjustments
- Clipboard behavior:
  - `copy-on-select = clipboard` for predictable `Cmd+V` paste behavior on macOS
- Scrollback:
  - `scrollback-limit = 50000` (balanced history/perf)
- Shader:
  - custom cursor shader enabled

## Keybinds Used

- `Cmd+T` new tab
- `Cmd+W` close surface
- `Cmd+N` new window
- `Cmd+D` split right
- `Cmd+Shift+D` split down
- `Cmd+C` copy
- `Cmd+V` paste
- `Ctrl+Shift+R` reload config

## Readability Notes

If highlighted text looks low-contrast in light theme, tune ANSI cyan:

```conf
palette = 6=#006d77
palette = 14=#008b99
```

## Performance Notes

- Keep shader enabled if you prefer it visually.
- Main lightweight lever is scrollback size; reduce below `50000` if needed.
- Reload config quickly with `Ctrl+Shift+R` after edits.

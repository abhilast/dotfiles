# Kitty Terminal Configuration

Fully optimized Kitty terminal setup for macOS with automatic dark/light theming, comprehensive keyboard shortcuts, and Neovim compatibility.

## Overview

- Automatic theme switching that follows macOS system appearance (Nord for dark, GitHub Light for light)
- macOS-first keybindings that preserve native text navigation while enabling Neovim Alt combos via right Option
- Display tuning for long-form reading on Retina panels (line height, spacing, cursor trails)
- Modular configuration split across `.conf` files for easy experimentation

## Configuration Location

Managed by chezmoi. Source files live under `dot_config/kitty/` in the dotfiles repo and are deployed to `~/.config/kitty/`.

## Directory Layout

| File | Purpose |
|------|---------|
| `kitty.conf` | Main configuration hub; includes `macos-shortcuts.conf` |
| `dark-theme.auto.conf` | Nord theme -- loaded automatically in dark mode |
| `light-theme.auto.conf` | GitHub Light theme -- loaded automatically in light mode |
| `no-preference-theme.auto.conf` | Nord fallback when system has no theme preference |
| `macos-shortcuts.conf` | All keyboard shortcuts grouped by feature |
| `reading-optimizations.conf` | Rendering tweaks for long reading sessions (not included by default) |
| `diff.conf` | Dracula-based color scheme for the kitty diff kitten |
| `dracula.conf` | Dracula theme definition (available for manual use) |
| `gruvbox_dark.conf` | Gruvbox Dark theme definition (available for manual use) |

## Theme System

Kitty's `*.auto.conf` naming convention enables automatic OS-appearance-aware theming without shell aliases or scripts:

- **Dark mode:** `dark-theme.auto.conf` activates Nord with thin strokes optimized for Retina
- **Light mode:** `light-theme.auto.conf` activates GitHub Light with high contrast
- **No preference:** Falls back to Nord (dark)

Additional theme files (Dracula, Gruvbox Dark) are available and can be activated by copying their contents into a `current-theme.conf` or by changing the auto conf files.

### Border Colors

All themes use consistent orange border colors for the active window (`#ff8800`) so the focused pane is always clearly visible.

## Keyboard Shortcuts

### Option/Alt Key Configuration

**Current Setting:** `macos_option_as_alt right`

- **Left Option:** macOS word navigation (Option+Left/Right for word jumping)
- **Right Option:** Alt key for Neovim plugins and terminal programs

### Tab Management

| Shortcut | Action |
|----------|--------|
| `Cmd+T` | New tab |
| `Cmd+W` | Close tab (with confirmation) |
| `Cmd+1-9` | Jump to tab 1-9 |
| `Cmd+Shift+]` | Next tab |
| `Cmd+Shift+[` | Previous tab |
| `Cmd+Shift+T` | Set tab title |
| `Cmd+Shift+Left/Right` | Move tab left/right |

### Window Management (Splits/Panes)

| Shortcut | Action |
|----------|--------|
| `Cmd+D` | Split vertically (new window to the right) |
| `Cmd+Shift+D` | Split horizontally (new window below) |
| `Cmd+Option+Arrow` | Navigate between windows |
| `Cmd+Option+1-9` | Jump to specific window |
| `Cmd+Ctrl+Arrow` | Resize current window |
| `Cmd+Shift+W` | Close current window (with confirmation) |
| `Cmd+Shift+N` | Detach window to new tab |

### Layout Management

| Shortcut | Action |
|----------|--------|
| `Cmd+Shift+L` | Next layout |
| `Cmd+Shift+Z` | Toggle stack layout |
| `Cmd+Shift+P` | Toggle tall layout |
| `Cmd+Shift+F` | Toggle fat layout |

Enabled layouts: splits (default), stack, tall, fat, horizontal, vertical, grid.

### Text Operations

| Shortcut | Action |
|----------|--------|
| `Cmd+C` | Copy |
| `Cmd+V` | Paste |
| `Cmd+A` | Select all |
| `Cmd+Plus/Minus` | Increase/decrease font size |
| `Cmd+0` | Reset font size |

### Navigation and Scrolling

| Shortcut | Action |
|----------|--------|
| `Cmd+Up/Down` | Page up/down |
| `Cmd+Home/End` | Scroll to top/bottom |
| `Option+Up/Down` | Line by line scrolling |
| `Cmd+F` | Fuzzy search in scrollback with fzf (falls back to less) |
| `Cmd+K` | Clear screen and scrollback |

### Window Resizing (Vim-style)

| Shortcut | Action |
|----------|--------|
| `Cmd+Shift+H` | Make window narrower |
| `Cmd+Shift+K` | Make window taller |
| `Cmd+Shift+J` | Make window shorter |
| `Cmd+Shift+0` | Reset window sizes |

### Session Management

| Shortcut | Action |
|----------|--------|
| `Cmd+Ctrl+S` | Save current session to JSON |
| `Cmd+Ctrl+L` | Load session info |
| `Cmd+Shift+S` | Save scrollback to file |

### Advanced Features

| Shortcut | Action |
|----------|--------|
| `Cmd+Shift+U` | Open URL hints (high-contrast colors) |
| `Cmd+Shift+O` | Open file path hints |
| `Cmd+Shift+E` | Unicode/emoji input |
| `Cmd+Ctrl+Space` | Unicode input |
| `Cmd+Shift+R` | Reload config |
| `Cmd+Enter` | Toggle fullscreen |
| `Ctrl+Shift+R` | Reload config (also in main kitty.conf) |

## Font and Display Settings

- **Font:** JetBrainsMono Nerd Font Mono, 15pt Medium (bold/italic auto-detected)
- **Font features:** `+zero` (dotted zero) and `+cv14` (improved ampersand)
- **Ligatures:** Always enabled
- **Text composition:** `1.3 5` (balanced stroke weight)
- **Line height:** 125% for comfortable reading
- **Character spacing:** 101%
- **Cursor:** Block shape with gentle blink (0.5s interval, stops after 10s)
- **Cursor trail:** Enabled with quick decay

## Performance Settings

- **Repaint delay:** 8ms (balanced responsiveness and CPU usage)
- **Input delay:** 2ms (very responsive typing feedback)
- **Sync to monitor:** Enabled to prevent screen tearing
- **Scrollback:** 50,000 lines with pixel scrolling
- **Scrollback pager:** `less` with raw control character support

## Window and Tab Bar

- **Tab bar:** Powerline style (slanted), always visible at top
- **Tab title format:** `{bell_symbol}{activity_symbol}{index}: {title}`
- **Window borders:** 1pt, orange active (`#ff8800`), dark inactive
- **Inactive window text alpha:** 0.6 (subtle dimming)
- **Window padding:** 2px top/bottom, 4px left/right (8px for single windows)
- **Window close confirmation:** Enabled for multiple tabs/windows (`-1`)

## Bell and Notifications

- **Audio bell:** Disabled
- **Visual bell:** 0.1s flash in `#cc6666` (red)
- **Tab bell indicator:** Bell emoji
- **Long-running command notification:** After 30 seconds when unfocused

## Shell and Remote Control

- **Shell integration:** Enabled (no sudo)
- **Remote control:** Socket-only (`unix:/tmp/kitty-{kitty_pid}`)
- **Term:** `xterm-256color`

## Diff Kitten

The `diff.conf` file provides a Dracula-themed color scheme for the built-in diff viewer (`kitty +kitten diff`).

## Customization Tips

### Adjusting Text Thickness

Edit `text_composition_strategy` in `kitty.conf`:

```
# Current balanced setting
text_composition_strategy 1.3 5

# Thinner text (dark themes)
text_composition_strategy 0.4 0

# Thicker text (light themes, high glare)
text_composition_strategy 1.7 0
```

### Changing Alt Key Behavior

```
# Current: Right Option as Alt (recommended)
macos_option_as_alt right

# Both Options as Alt (lose macOS word navigation)
macos_option_as_alt both

# Disable Alt key entirely
macos_option_as_alt no
```

### Using the Reading Optimizations

The `reading-optimizations.conf` file contains additional tweaks for extended reading sessions. To enable it, add to `kitty.conf`:

```
include reading-optimizations.conf
```

Note: some settings in that file overlap with `kitty.conf`, so the include order determines which takes effect.

## Troubleshooting

**Theme not applying?**
- The `*.auto.conf` files require Kitty 0.29+. Press `Ctrl+Shift+R` to reload.
- Restart Kitty if automatic theme switching is not responding to system appearance changes.

**Alt key not working in Neovim?**
- Use the Right Option key for Alt combinations.
- Verify `macos_option_as_alt` is set to `right`.

**Text too thin or too thick?**
- Adjust `text_composition_strategy` -- lower first value means thinner text.

**Shortcuts conflicting?**
- Edit `macos-shortcuts.conf` to customize. All shortcuts are in one file for easy review.

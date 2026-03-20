# Ghostty Configuration

## Overview

[Ghostty](https://ghostty.org) is a fast, feature-rich, and cross-platform terminal emulator written in Zig. This configuration provides a comfortable development environment with appearance-aware theming, split pane management, and macOS-native keybindings.

## Configuration Location

Managed by chezmoi. Source files live under `dot_config/ghostty/` in the dotfiles repo and are deployed to `~/.config/ghostty/`.

| File | Purpose |
|------|---------|
| `config` | Main configuration (font, window, keybindings, theme) |
| `profiles.conf` | Reference profiles for different workflows (coding, presentation, reading, minimal) |
| `themes.conf` | Theme reference and switching notes |

## Key Settings

### Font

- **Family:** JetBrainsMono Nerd Font Mono
- **Size:** 15pt
- **Cell height:** 120% for comfortable reading
- **Cell width:** 102% for reduced eye strain
- **Font thicken:** Enabled for Retina display rendering

### Theme

The active theme uses Ghostty's appearance-aware syntax to automatically match the system light/dark mode:

```
theme = light:Builtin Light,dark:Nord
```

- **Dark mode:** Nord
- **Light mode:** Builtin Light

### Cursor

- Block style, no blink
- Cursor thickness: 2

### Window and Layout

- Default size: 120 columns x 35 rows
- Window state saved between sessions (`window-save-state = always`)
- Balanced padding (6px horizontal, 4px vertical)
- Split divider color: `#ff8800` (orange) for visibility
- Quits after last window is closed

### Scrollback

- 50,000 lines of scrollback history

### Mouse and Interaction

- Mouse hides while typing
- Copy-on-select sends to system clipboard
- Trailing spaces trimmed from clipboard
- URLs auto-detected and clickable

### macOS Settings

- Option key treated as Alt (`macos-option-as-alt = true`) -- both Option keys send Alt
- Native titlebar style
- Close confirmation always shown

### Clipboard

- Full read/write clipboard access enabled

## Keyboard Shortcuts

### Tab Management

| Shortcut | Action |
|----------|--------|
| `Cmd+T` | New tab |
| `Cmd+W` | Close surface |
| `Cmd+N` | New window |
| `Cmd+1-5` | Jump to tab 1-5 |

### Split Pane Management

| Shortcut | Action |
|----------|--------|
| `Cmd+D` | Split right (vertical) |
| `Cmd+Shift+D` | Split down (horizontal) |
| `Cmd+[` | Go to previous split |
| `Cmd+]` | Go to next split |
| `Cmd+Shift+Enter` | Toggle split zoom |

### Text Operations

| Shortcut | Action |
|----------|--------|
| `Cmd+C` | Copy to clipboard |
| `Cmd+V` | Paste from clipboard |
| `Cmd+Plus` | Increase font size |
| `Cmd+Minus` | Decrease font size |
| `Cmd+0` | Reset font size |

### Alt/Arrow Key Passthrough

Alt+arrow keys are configured to send xterm CSI sequences so they pass through correctly to terminal programs like Zellij:

| Shortcut | Action |
|----------|--------|
| `Alt+Left` | Sends `\x1b[1;3D` (passthrough) |
| `Alt+Right` | Sends `\x1b[1;3C` (passthrough) |
| `Alt+Up` | Unbound |
| `Alt+Down` | Unbound |

### Other

| Shortcut | Action |
|----------|--------|
| `Ctrl+Shift+R` | Reload config |

## Profiles (Reference)

The `profiles.conf` file contains commented-out reference profiles for different workflows. These are not active by default but document recommended settings for:

- **Coding:** Smaller font (12pt), reduced scrollback, no transparency
- **Presentation:** Larger font (18pt), solid background, high contrast
- **Reading:** Comfortable font (16pt), large scrollback, slight transparency
- **Minimal:** Stripped down for maximum performance

## Usage Notes

- Ghostty automatically switches between light and dark themes based on macOS system appearance.
- Both Option keys act as Alt, which is useful for terminal programs but means macOS word navigation (Option+arrows) is replaced by the Alt passthrough bindings.
- Shell integration is set to `zsh`.
- The resize overlay is disabled for a cleaner experience.

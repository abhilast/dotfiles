# Zellij

[Zellij](https://zellij.dev/) is a terminal multiplexer (similar to tmux or screen) with a plugin system, built-in layout engine, and session management. It lets you split your terminal into panes and tabs, manage multiple sessions, and recover work after disconnection.

## Configuration

The config file is `config.kdl.tmpl` -- a [KDL](https://kdl.dev/) file processed through chezmoi's template engine. The `.tmpl` extension tells chezmoi to evaluate Go template expressions before writing the final `config.kdl`.

### Chezmoi Template: Auto Dark/Light Theme

The config uses chezmoi templating to detect the system appearance at `chezmoi apply` time and select the appropriate theme:

```
{{ if eq .chezmoi.os "darwin" -}}
{{   $appearance := output "sh" "-c" "defaults read -g AppleInterfaceStyle 2>/dev/null || echo Light" | trim -}}
{{   if eq $appearance "Dark" -}}
theme "tokyo-night-dark"
{{   else -}}
theme "tokyo-night-light"
{{   end -}}
{{ else -}}
theme "tokyo-night-dark"
{{ end -}}
```

On macOS, this reads the `AppleInterfaceStyle` system default. If it returns `"Dark"`, the dark theme is used; otherwise, the light theme is applied. On non-macOS systems, it defaults to dark.

**Important:** The theme is set at apply time, not dynamically. Run `chezmoi apply` after changing your system appearance to update the theme.

### Theme Definitions

Both Tokyo Night variants are defined inline in the config:

| Color    | Dark        | Light       |
|----------|-------------|-------------|
| fg       | `#a9b1d6`   | `#343b58`   |
| bg       | `#1a1b26`   | `#d5d6db`   |
| black    | `#32344a`   | `#0f0f14`   |
| red      | `#f7768e`   | `#8c4351`   |
| green    | `#9ece6a`   | `#485e30`   |
| yellow   | `#e0af68`   | `#8f5e15`   |
| blue     | `#7aa2f7`   | `#34548a`   |
| magenta  | `#ad8ee6`   | `#5a4a78`   |
| cyan     | `#449dab`   | `#0f4b6e`   |
| white    | `#787c99`   | `#343b58`   |
| orange   | `#ff9e64`   | `#965027`   |

### Other Settings

- **`show_startup_tips false`** -- Disables the startup tips overlay.
- **`clear-defaults=true`** on keybinds -- All default keybindings are cleared and replaced with the explicit bindings below.

## Keybinding Reference

Zellij uses a modal keybinding system. You enter a mode with a prefix key, perform actions, then return to normal mode. All navigation within modes uses vim-style `h/j/k/l` keys alongside arrow key equivalents.

### Mode Entry (from Normal mode)

| Key        | Mode      |
|------------|-----------|
| `Ctrl p`   | Pane      |
| `Ctrl t`   | Tab       |
| `Ctrl n`   | Resize    |
| `Ctrl h`   | Move      |
| `Ctrl s`   | Scroll    |
| `Ctrl o`   | Session   |
| `Ctrl b`   | Tmux      |
| `Ctrl g`   | Locked    |

Pressing `Esc` or `Enter` returns to normal mode from most modes.

### Pane Mode (`Ctrl p`)

| Key   | Action                         |
|-------|--------------------------------|
| `h/j/k/l` | Move focus (left/down/up/right) |
| `n`   | New pane                       |
| `d`   | New pane down                  |
| `r`   | New pane right                 |
| `s`   | New pane (stacked)             |
| `x`   | Close pane                     |
| `f`   | Toggle fullscreen              |
| `w`   | Toggle floating panes          |
| `e`   | Toggle embed or floating       |
| `i`   | Toggle pane pinned             |
| `z`   | Toggle pane frames             |
| `c`   | Rename pane                    |
| `p`   | Switch focus                   |

### Tab Mode (`Ctrl t`)

| Key   | Action                         |
|-------|--------------------------------|
| `h/j/k/l` | Navigate tabs                  |
| `n`   | New tab                        |
| `x`   | Close tab                      |
| `r`   | Rename tab                     |
| `1-9` | Go to tab by number            |
| `s`   | Toggle sync tab                |
| `b`   | Break pane to new tab          |
| `[`   | Break pane left                |
| `]`   | Break pane right               |
| `Tab` | Toggle between last two tabs   |

### Resize Mode (`Ctrl n`)

| Key   | Action                         |
|-------|--------------------------------|
| `h/j/k/l` | Increase size in direction     |
| `H/J/K/L` | Decrease size in direction     |
| `+/=` | Increase overall               |
| `-`   | Decrease overall               |

### Move Mode (`Ctrl h`)

| Key   | Action                         |
|-------|--------------------------------|
| `h/j/k/l` | Move pane in direction         |
| `n/Tab` | Move pane (next position)    |
| `p`   | Move pane backwards            |

### Scroll Mode (`Ctrl s`)

| Key   | Action                         |
|-------|--------------------------------|
| `j/k` | Scroll down/up                 |
| `h/l` | Page up/down                   |
| `d`   | Half page down                 |
| `u`   | Half page up                   |
| `Ctrl f` | Page down                   |
| `Ctrl b` | Page up                     |
| `e`   | Edit scrollback in `$EDITOR`   |
| `s`   | Enter search mode              |

### Search Mode (from Scroll)

| Key   | Action                         |
|-------|--------------------------------|
| `n`   | Search down (next)             |
| `p`   | Search up (previous)           |
| `c`   | Toggle case sensitivity        |
| `w`   | Toggle wrap                    |
| `o`   | Toggle whole word              |

### Session Mode (`Ctrl o`)

| Key   | Action                         |
|-------|--------------------------------|
| `d`   | Detach                         |
| `w`   | Session manager                |
| `c`   | Configuration plugin           |
| `p`   | Plugin manager                 |
| `a`   | About                          |
| `s`   | Share session                  |

### Tmux Mode (`Ctrl b`)

Provides tmux-compatible bindings for users with muscle memory from tmux.

| Key   | Action                         |
|-------|--------------------------------|
| `"`   | Split pane down                |
| `%`   | Split pane right               |
| `h/j/k/l` | Move focus                |
| `z`   | Toggle fullscreen              |
| `c`   | New tab                        |
| `n`   | Next tab                       |
| `p`   | Previous tab                   |
| `,`   | Rename tab                     |
| `[`   | Enter scroll mode              |
| `o`   | Focus next pane                |
| `x`   | Close pane                     |
| `d`   | Detach                         |
| `Space` | Next swap layout             |

### Global Shortcuts (available in all unlocked modes)

| Key         | Action                         |
|-------------|--------------------------------|
| `Alt h/l`   | Move focus or tab left/right   |
| `Alt j/k`   | Move focus down/up             |
| `Alt n`     | New pane                       |
| `Alt f`     | Toggle floating panes          |
| `Alt +/=`   | Increase size                  |
| `Alt -`     | Decrease size                  |
| `Alt [/]`   | Previous/next swap layout      |
| `Alt i/o`   | Move tab left/right            |
| `Alt p`     | Toggle pane in group           |
| `Alt Shift p` | Toggle group marking         |
| `Ctrl q`    | Quit zellij                    |

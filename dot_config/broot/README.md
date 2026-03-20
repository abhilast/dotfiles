# Broot Configuration

## Overview

[Broot](https://github.com/Canop/broot) is a terminal file navigator designed to get you where you need to go with minimal keystrokes. It provides fuzzy search, file previews, and a tree-based view of directories.

## Configuration

This directory is managed by [chezmoi](https://www.chezmoi.io/) and deployed to `~/.config/broot/`.

### Files

- `conf.hjson` -- Main configuration (flags, display, special paths, imports)
- `verbs.hjson` -- Custom commands and keybindings
- `skins/` -- Color themes (dark-blue for dark terminals, white for light terminals)

### Key Settings

| Setting | Value | Description |
|---------|-------|-------------|
| `show_selection_mark` | `true` | Marks the selected line with a triangle |
| `enable_kitty_keyboard` | `true` | Full keyboard support in Kitty-compatible terminals |
| `content_search_max_file_size` | `10MB` | Skip files larger than this in content searches |
| `lines_before_match_in_preview` | `1` | Context lines above matches in filtered preview |
| `lines_after_match_in_preview` | `1` | Context lines below matches in filtered preview |

### Special Paths

- `/media` -- Never listed or summed (excluded from searches)
- `~/.config` -- Always shown (even though it starts with a dot)
- `trav` -- Always shown and listed, never summed

### Skin / Theme

The theme is selected automatically based on terminal luminance:

- **Dark / Unknown terminals** -- `skins/dark-blue.hjson`
- **Light terminals** -- `skins/white.hjson`

### Custom Keybindings

| Key | Action |
|-----|--------|
| `Ctrl+E` | Edit file in `$EDITOR` |
| `Ctrl+B` | Create a backup copy of selected file |
| `Ctrl+T` | Open terminal in current directory |
| `Alt+H` | Toggle hidden files |
| `Alt+F` | Toggle fold/unfold all directories |

### Custom Verbs

| Invocation | Shortcut | Description |
|------------|----------|-------------|
| `edit` | `e` | Open file in `$EDITOR` |
| `create {subpath}` | -- | Create a new file in `$EDITOR` |
| `git_diff` | `gd` | Run `git difftool` on selected file |
| `backup {version}` | -- | Copy file with version suffix |
| `terminal` | -- | Launch `$SHELL` in working directory |

## Usage

```bash
# Use br function to change directories
br              # Start in current directory
br ~/projects   # Start in specific directory

# Inside broot
/pattern        # Regex search
c/text          # Search in file contents
:ss             # Sort by size
:sd             # Sort by date
```

## Tips

- Use `br` instead of `broot` to enable directory changing on exit
- Just start typing to filter files (no command needed)
- Press Space to preview files
- Use Alt+Enter to cd to selected directory

# LSD Configuration

## Overview

[LSD (LSDeluxe)](https://github.com/lsd-rs/lsd) is a modern replacement for the `ls` command with colors, icons, tree-view, and more.

## Configuration

This directory is managed by [chezmoi](https://www.chezmoi.io/) and deployed to `~/.config/lsd/`.

### Files

- `config.yaml` -- Main configuration

### Key Settings

| Setting | Value | Description |
|---------|-------|-------------|
| `classic` | `false` | Modern mode with icons and colors |
| `color.when` | `always` | Always colorize output |
| `color.theme` | `default` | Default color theme |
| `date` | `date` | Standard date format |
| `icons.when` | `auto` | Show icons when terminal supports them |
| `icons.theme` | `fancy` | Nerd Font icons |
| `layout` | `grid` | Grid layout by default |
| `size` | `default` | Default size format |
| `header` | `false` | No column headers |
| `symlink-arrow` | `=>` | Unicode arrow for symlink targets |
| `hyperlink` | `never` | No clickable file links |

### Column Layout (Long Format)

The `blocks` setting defines columns in long/tree views:

1. `permission`
2. `user`
3. `group`
4. `size`
5. `date`
6. `name`

### Ignored Globs

The following patterns are hidden by default:

- `.git`, `.hg`, `.svn`
- `node_modules`
- `.DS_Store`

### Sorting

- Sorted by `name`
- No directory grouping (`dir-grouping: none`)
- No reverse order

## Usage

```bash
lsd             # Basic listing
lsd -l          # Long format with details
lsd -la         # Include hidden files
lsd -lt         # Sort by modification time
lsd -lS         # Sort by size
lsd --tree      # Tree view
lsd --tree -d 2 # Tree view, max depth 2
```

## Tips

- Requires a [Nerd Font](https://www.nerdfonts.com/) for icons to display correctly
- Use `--config-file` to test alternative configurations
- Combine with `bat` for a complete modern CLI experience
- Use `--blocks` to customize output columns on the fly

# Atuin Configuration

## Overview

[Atuin](https://github.com/ellie/atuin) replaces the default shell history with a SQLite database-backed system providing powerful fuzzy search, sync capabilities, and privacy filtering. It enhances history search (Ctrl+R) with context-aware features and statistics.

## Configuration

This directory is managed by [chezmoi](https://www.chezmoi.io/) and deployed to `~/.config/atuin/`.

### Files

- `config.toml` -- Main configuration with defaults and sync settings

### Key Settings

The configuration is mostly defaults with a few notable overrides:

- **`enter_accept = true`** -- Immediately execute the selected command on Enter (press Tab to edit instead)
- **`sync.records = true`** -- Enables sync v2 for cross-machine history synchronization
- All other values (search mode, filter mode, style, etc.) use Atuin's built-in defaults

### Defaults in Effect

Since most settings are commented out, the following defaults apply:

| Setting | Default |
|---------|---------|
| Search mode | `fuzzy` |
| Filter mode | `global` |
| Style | `auto` |
| Secrets filter | `true` (auto-detects AWS keys, GitHub PATs, Slack tokens, etc.) |
| Update check | `true` |
| Show preview | `true` |
| Exit mode | `return-original` |

## Usage

### Basic Search

```bash
Ctrl+R              # Open fuzzy search interface
```

### Search Interface Keybindings

| Key | Action |
|-----|--------|
| `Ctrl+R` | Open search |
| `Type` | Fuzzy search |
| Up/Down or `Ctrl+P/N` | Navigate results |
| `Enter` | Execute command |
| `Tab` | Insert without executing |
| `Ctrl+D` | Delete entry |
| `Esc` | Cancel |

### Search Filters

```bash
# Basic search
docker                           # Find docker commands

# Advanced filters
:host laptop                     # Commands from specific host
:cwd /project                    # Commands in directory
:before 2024-01-01               # Before date
:after 2024-01-01                # After date

# Combined filters
docker :after 2024-01-01 :cwd /work
```

### Statistics

```bash
atuin stats                      # Overall command statistics
```

## Tips

- Use Tab to insert a command for editing without executing
- Combine filters for precise searches
- Use `:cwd` filter to find project-specific commands
- The built-in secrets filter catches AWS keys, GitHub PATs, Slack tokens, and Stripe keys automatically

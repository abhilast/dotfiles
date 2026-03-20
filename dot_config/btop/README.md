# Btop Configuration

## Overview

[Btop](https://github.com/aristocratos/btop) is a resource monitor that shows usage and stats for processor, memory, disks, network, and processes. It provides a modern TUI interface with real-time graphs and detailed system information.

## Configuration

This directory is managed by [chezmoi](https://www.chezmoi.io/) and deployed to `~/.config/btop/`.

### Files

- `btop.conf` -- Main configuration

### Key Settings

| Setting | Value | Description |
|---------|-------|-------------|
| `color_theme` | `TTY` | Uses the TTY built-in theme |
| `theme_background` | `false` | Transparent background (uses terminal background) |
| `truecolor` | `true` | 24-bit color support enabled |
| `graph_symbol` | `braille` | Highest resolution graph characters |
| `rounded_corners` | `true` | Rounded box corners |
| `terminal_sync` | `true` | Synchronized output to reduce flickering |
| `update_ms` | `100` | Very fast 100ms update interval |
| `shown_boxes` | `cpu net proc mem` | All four main panels visible |
| `save_config_on_exit` | `true` | Auto-saves settings changes |

### Layout Presets

Three presets are configured (cycle with `p`):

1. CPU + Process list (alternate positions)
2. CPU + Memory + Network (default layout)
3. CPU (block) + Network (tty symbols)

### CPU Display

- Shows CPU frequency and temperature
- Dual graph (upper/lower, lower inverted) with auto-detected stats
- Shows system uptime and power consumption in watts
- Clock displayed at top of screen (`%X` format)

### Process Settings

- Sorted by `cpu lazy` (smoothed over time, easier to follow)
- Per-process CPU graphs enabled
- Memory shown in bytes (not percent)
- Color and gradient enabled in process list

### Memory / Disk

- Graphs for memory values (not meters)
- Swap shown both in memory box and as a disk entry
- Disk info panel enabled
- Base-10 sizes (KB = 1000)

### Network

- Auto-rescaling graphs
- Download/upload sync enabled
- Battery stats shown when present

## Usage

```bash
btop            # Launch btop

# Keyboard shortcuts
h               # Toggle help
q / Esc         # Quit
f               # Filter processes
t               # Toggle tree view
p               # Cycle layout presets
k / Up          # Move up
j / Down        # Move down
Enter           # Show process details
d / Delete      # Kill process
Space           # Pause updates
1-4             # Toggle boxes (cpu/mem/net/proc)
```

## Tips

- The 100ms update interval is very responsive; increase `update_ms` if CPU usage is a concern
- Use layout presets (`p`) to quickly switch between focused views
- Transparent background blends well with terminal themes

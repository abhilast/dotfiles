# LinearMouse Configuration

## Overview

[LinearMouse](https://linearmouse.app/) is a macOS utility that provides fine-grained control over mouse pointer acceleration and scrolling behavior. It supports per-device and per-application configuration schemes.

## Configuration

This directory is managed by [chezmoi](https://www.chezmoi.io/) and deployed to `~/.config/linearmouse/`.

### Files

- `linearmouse.json` -- Device schemes and pointer/scroll settings (schema v0.10.1)

### Device Schemes

The configuration defines four schemes for two mice:

#### HyperX Pulsefire Haste Wireless

| Setting | Value |
|---------|-------|
| Acceleration | `4` (but disabled) |
| Disable acceleration | `true` |

Raw 1:1 pointer movement with no macOS acceleration curve applied.

#### Magic Mouse (Global)

| Setting | Value |
|---------|-------|
| Pointer acceleration | `3` |
| Pointer speed | `0` |
| Scroll acceleration | `1` |
| Vertical scroll speed | `8` |
| Horizontal scroll speed | `0.1` |

Standard macOS acceleration with boosted vertical scrolling and minimal horizontal scroll sensitivity.

#### Magic Mouse (Google Chrome)

An app-specific override for Chrome:

| Setting | Value |
|---------|-------|
| Pointer acceleration | `2` (reduced from global) |
| Horizontal scroll acceleration | `0.25` |
| Horizontal scroll speed | `0.1` |

Reduces pointer acceleration and tames horizontal scrolling in Chrome to prevent accidental back/forward navigation.

#### AB's Magic Mouse

| Setting | Value |
|---------|-------|
| Pointer acceleration | `4.2429` |
| Pointer speed | `0.2446` |
| Vertical scroll acceleration | `1` |

A second Magic Mouse profile with custom acceleration and speed values.

## Usage

LinearMouse runs as a background macOS application and applies these schemes automatically based on the connected device and active application.

```bash
# Install
brew install --cask linearmouse
```

## Tips

- Grant Accessibility permissions in System Settings > Privacy & Security for LinearMouse to function
- Enable "Launch at login" for consistent behavior across restarts
- Use the LinearMouse GUI to adjust values interactively; changes are saved to this JSON file
- Restart the app after macOS updates if pointer behavior changes unexpectedly

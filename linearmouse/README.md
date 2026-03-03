# LinearMouse Configuration

## Overview
This package tracks LinearMouse config as JSON under:
- `linearmouse/.config/linearmouse/linearmouse.json`

## Install
```bash
cd ~/dotfiles
stow linearmouse
```

## What Is Configured
Current JSON uses per-device schemes, including:
- HyperX Pulsefire Haste Wireless profile (acceleration disabled)
- Magic Mouse profiles (general + app-specific override for Chrome)

## Notes
- Repo source of truth is `linearmouse.json` in this package.
- If app-level storage format changes in a future LinearMouse release, re-export and update this file.

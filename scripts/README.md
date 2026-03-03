# Scripts

## Overview
Operational scripts for install validation, syncing, benchmarking, and macOS helpers.

## Core Workflows

### `sync.sh`
```bash
./scripts/sync.sh
```
- Pulls latest from git
- Runs `brew bundle`
- Re-stows all top-level packages except `.git` and `scripts`

### `health-check.sh`
```bash
./scripts/health-check.sh
```
- Checks stow conflicts
- Verifies symlink targets under `~/.config`
- Checks Brewfile dependencies (`brew` entries)
- Prints zsh startup timing samples

### `backup-configs.sh`
```bash
./scripts/backup-configs.sh
```
- Copies current `~/.config/<package>` directories to `~/.dotfiles-backup/<timestamp>/`

## ZSH / Performance

### `benchmark.sh`
```bash
./scripts/benchmark.sh
```
- Uses `hyperfine` when available
- Falls back to `/usr/bin/time`

### `profile-zsh-startup.sh`
```bash
./scripts/profile-zsh-startup.sh
```
- Times bare shell, `.zshenv`, and full interactive startup
- Runs `zprof` output via a temporary profile file

### `zsh-benchmark-advanced.sh`
```bash
./scripts/zsh-benchmark-advanced.sh
```
- Advanced timing suite with optional comparison and trace modes

### `test-completion-demo.sh`
```bash
./scripts/test-completion-demo.sh
```
- Prints completion-related diagnostics/help text

### `migrate-to-zinit.sh`
```bash
./scripts/migrate-to-zinit.sh
```
- Legacy migration helper retained in repo

## Ghostty

### `ghostty-theme-switcher.sh`
```bash
./scripts/ghostty-theme-switcher.sh --list
./scripts/ghostty-theme-switcher.sh nord
```
- Lists and applies Ghostty themes by editing `~/.config/ghostty/config`

## Git Worktree Helper

### `wt`
```bash
./scripts/wt new <repo> <name>
./scripts/wt ls <repo>
./scripts/wt rm <repo> <name>
./scripts/wt prune <repo>
```
Defaults:
- `WT_ROOT=~/repos/skates`
- `WT_REMOTE_BASE=origin/main`

## macOS Helpers
- `scripts/mac/toggle_dark_mode.sh`
- `scripts/mac/toggle_dock_position.sh`
- `scripts/mac/toggle-dock-visibility.sh`
- `scripts/mac/rc-toggle-dock.sh`
- `scripts/mac/set_sound_io_studio_display.sh`
- `scripts/mac/switch_audio_source.sh`

## Notes
- Prefer reading script source before running state-changing helpers.
- If docs and behavior diverge, treat script source as authoritative.

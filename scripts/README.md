# Scripts

Scripts are on PATH via `.zshenv`. Run them directly by name.

## ZSH / Performance

### `benchmark.sh`
```bash
benchmark.sh
```
- Uses `hyperfine` when available
- Falls back to `/usr/bin/time`

### `profile-zsh-startup.sh`
```bash
profile-zsh-startup.sh
```
- Times bare shell, `.zshenv`, and full interactive startup
- Runs `zprof` output via a temporary profile file

## Ghostty

### `ghostty-theme-switcher.sh`
```bash
ghostty-theme-switcher.sh --list
ghostty-theme-switcher.sh nord
```
- Lists and applies Ghostty themes by editing `~/.config/ghostty/config`

## Git Worktree Helper

### `wt`
```bash
wt new <repo> <name>
wt ls <repo>
wt rm <repo> <name>
wt prune <repo>
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
- `chezmoi doctor` and `chezmoi verify` replace the former `health-check.sh` for setup validation.

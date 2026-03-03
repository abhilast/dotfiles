# Ripgrep Configuration

## Overview
This package provides your shared ripgrep defaults through:
- `ripgrep/.config/.ripgreprc`

Your shell loads it via:
- `RIPGREP_CONFIG_PATH="$HOME/.config/.ripgreprc"` in `zsh/.zshenv`

## Install
```bash
cd ~/dotfiles
stow ripgrep
```

## Common Usage
```bash
rg pattern
rg -i pattern
rg -n pattern
rg -C 3 pattern
rg -l pattern
rg --files
rg --json pattern
```

## Current Default Options
From `.ripgreprc`:
- `--hidden`
- `--follow`
- `--smart-case`
- `--line-number`
- `--no-heading`
- glob exclusions for build/cache/media/binary lockfiles

## Notes
- Because `RIPGREP_CONFIG_PATH` is exported in your zsh env, ripgrep behavior depends on that env var being present in the shell session.

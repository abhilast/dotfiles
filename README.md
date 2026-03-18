# Dotfiles

Personal dotfiles for macOS and Ubuntu, managed with [chezmoi](https://www.chezmoi.io/).

## What's Included

**Core:** Neovim (NvChad-based with LSP, FZF, Telescope), ZSH (Zinit, p10k, lazy-loading), Git (delta diffs, difftastic, aliases), Kitty + Ghostty terminals

**Dev tools:** Go (revive linter), Atuin (shell history), Broot, Ripgrep, LSD, Lazygit

**System:** Btop, LinearMouse

## Bootstrap

### macOS

```bash
# Fresh Mac (no Homebrew needed):
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply abhilast

# Or with Homebrew already installed:
brew install chezmoi && chezmoi init --apply abhilast
```

What happens: chezmoi prompts for email/name, installs Homebrew (if missing), runs `brew bundle` to install all packages from `Brewfile`, applies all configs, syncs Neovim plugins, and sets the default shell to ZSH.

### Ubuntu / Debian

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply abhilast
```

What happens: chezmoi prompts for email/name, installs base dependencies via `apt` (from `Aptfile`), applies all configs, syncs Neovim plugins, and sets the default shell to ZSH.

The bootstrap scripts detect the OS automatically -- `Brewfile` is used on macOS, `Aptfile` on Linux. All config files are identical across platforms; only the package installation differs.

## Daily Workflow

```bash
chezmoi edit ~/.zshrc       # Edit config (opens in editor)
chezmoi apply               # Apply all changes to $HOME
chezmoi diff                # Preview what would change
chezmoi cd                  # Enter the source directory
chezmoi update              # Pull latest + apply (cross-machine sync)
```

## Adding New Tools

```bash
chezmoi cd
# Add the tool to Brewfile (macOS) and/or Aptfile (Ubuntu)
# Add config files with chezmoi naming (dot_ prefix)
chezmoi apply
git add . && git commit && git push
```

## Shell Helpers

Core shell helpers (from ZSH aliases and functions):

```bash
pj              # fuzzy-switch projects
wtn <branch>    # create/switch to a git worktree branch
wtl             # list/jump worktrees
wtr <target>    # remove a worktree
prn             # push branch + open PR via gh
```

## Scripts

Utility scripts in `scripts/` (on PATH via `.zshenv`):

- `benchmark.sh` -- shell startup benchmarking with hyperfine
- `profile-zsh-startup.sh` -- detailed zsh startup profiling
- `ghostty-theme-switcher.sh` -- switch Ghostty themes
- `wt` -- git worktree management helper
- `scripts/mac/` -- macOS helpers (dark mode, dock, audio)

## Git Worktree Helper (`wt`)

A helper script at `scripts/wt` (on PATH after shell reload):

```bash
wt new cloudsync-pro hero-fix
wt ls cloudsync-pro
wt rm cloudsync-pro hero-fix
wt prune cloudsync-pro
```

Defaults:
- Root workspace: `~/repos/skates`
- New worktree path: `~/repos/skates/<repo>-wt-<name>`
- Base branch: `origin/main`

Overrides:
- `WT_ROOT` to change workspace root
- `WT_REMOTE_BASE` to change default branch base

## Validation

```bash
chezmoi doctor              # Health check
chezmoi verify              # All files match source
chezmoi diff                # No drift
hyperfine 'zsh -i -c exit'  # Startup benchmark (<200ms target)
```

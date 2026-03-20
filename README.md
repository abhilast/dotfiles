# Dotfiles

Personal dotfiles for macOS and Ubuntu, managed with [chezmoi](https://www.chezmoi.io/).

## What's Included

**Core:** Neovim (NvChad-based with LSP, FZF, Telescope), ZSH (Zinit, p10k, lazy-loading), Git (delta diffs, difftastic, aliases), Kitty + Ghostty terminals

**Dev tools:** Go (revive linter), Atuin (shell history), Broot, Ripgrep, LSD, Lazygit

**System:** Btop, Zellij, LinearMouse

## Per-Tool Documentation

Each tool has its own README with detailed configuration reference:

| Tool | Config Location | Documentation |
|------|----------------|---------------|
| ZSH | `dot_zshrc`, `dot_zsh_*` | [ZSH.md](ZSH.md) -- aliases, functions, completions, performance |
| Neovim | `dot_config/nvim/` | [README](dot_config/nvim/README.md) -- keybindings, plugins, LSP |
| Ghostty | `dot_config/ghostty/` | [README](dot_config/ghostty/README.md) -- themes, profiles, splits |
| Kitty | `dot_config/kitty/` | [README](dot_config/kitty/README.md) -- shortcuts, themes, diff |
| Git | `dot_gitconfig.tmpl` | [below](#git-configuration) -- aliases, delta, difftastic |
| Atuin | `dot_config/atuin/` | [README](dot_config/atuin/README.md) -- shell history sync |
| Broot | `dot_config/broot/` | [README](dot_config/broot/README.md) -- tree navigation, verbs |
| Btop | `dot_config/btop/` | [README](dot_config/btop/README.md) -- resource monitoring |
| Lazygit | `dot_config/lazygit/` | [README](dot_config/lazygit/README.md) -- git TUI with difftastic |
| Zellij | `dot_config/zellij/` | [README](dot_config/zellij/README.md) -- terminal multiplexer, vim keys |
| LSD | `dot_config/lsd/` | [README](dot_config/lsd/README.md) -- modern ls replacement |
| LinearMouse | `dot_config/linearmouse/` | [README](dot_config/linearmouse/README.md) -- mouse acceleration |
| Scripts | `scripts/` | [README](scripts/README.md) -- utility scripts |

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

## Git Configuration

Git config lives at root level (`dot_gitconfig.tmpl`) since it deploys to `~/.gitconfig`. It uses chezmoi templates to set user email/name from prompts and auto-detect macOS dark/light mode for delta.

### Aliases

| Alias | Command | Purpose |
|-------|---------|---------|
| `st` | `status -sb` | Short status |
| `ll` | `log --oneline --graph -15` | Compact log |
| `lg` | `log --graph --pretty=...` | Decorated log |
| `co` | `checkout` | Switch branches |
| `br` | `branch` | Branch management |
| `cm` | `commit -m` | Quick commit |
| `cam` | `commit -am` | Commit all with message |
| `d` / `dc` | `diff` / `diff --cached` | View changes |
| `dt` / `dtc` | `difftool` / `difftool --cached` | Difftastic view |
| `s` / `sp` / `sl` | `stash` / `stash pop` / `stash list` | Stash shortcuts |
| `f` / `fo` | `fetch` / `fetch origin` | Fetch |
| `p` / `pl` | `push` / `pull` | Push/pull |
| `rb` / `rbi` | `rebase` / `rebase -i` | Rebase |
| `cleanup` | merged branch cleanup | Delete merged branches |
| `find` | log grep | Search commit messages |

### Diff Tools

- **Delta** -- primary pager for all git diffs. Auto-detects macOS appearance (dark/light) via chezmoi template. Side-by-side with line numbers.
- **Difftastic** -- structural diff tool (`git dt` / `git dtc`). Shows AST-level changes instead of line-level.
- **Nvimdiff** -- merge conflict resolution (`git mergetool`). Uses diff3 conflict style.

### Chezmoi Template Features

The git config uses `{{ .email }}` and `{{ .name }}` from chezmoi's data prompts, and detects macOS `AppleInterfaceStyle` at `chezmoi apply` time to set `delta.light` accordingly.

## Validation

```bash
chezmoi doctor              # Health check
chezmoi verify              # All files match source
chezmoi diff                # No drift
hyperfine 'zsh -i -c exit'  # Startup benchmark (<200ms target)
```

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A GNU Stow-managed dotfiles monorepo for macOS. Each top-level directory is a stow package that symlinks into `$HOME`. See AGENTS.md for coding style, commit conventions, and testing guidelines.

## Essential Commands

```bash
# Bootstrap (macOS only - installs Homebrew, stows everything)
./install.sh

# Restow after editing a package (always use -R for restow)
stow -R <package>            # e.g., stow -R zsh nvim kitty

# Install/update Homebrew dependencies
brew bundle --file Brewfile

# Validate setup (symlinks, dependencies, health)
./scripts/health-check.sh

# Syntax-check zsh configs (fast, no side effects)
zsh -n zsh/.zshenv zsh/.zshrc

# Sync Neovim plugins headlessly
nvim --headless "+Lazy! sync" +qa

# Measure shell startup performance
./scripts/benchmark.sh
./scripts/profile-zsh-startup.sh

# Sync dotfiles across machines (pull + brew bundle + restow)
./scripts/sync.sh
```

## Architecture

### Stow Package Dependency Order

Stowing order matters. `install.sh` uses this sequence:
```
git → zsh → nvim → kitty → ghostty → ripgrep → lsd → btop → broot → atuin → go → linearmouse
```
Git must be first (other tools reference gitconfig). ZSH second (sets PATH and env used by everything else).

### ZSH Configuration Chain

```
.zshenv          → Environment vars, PATH, FZF colors, tool config (loaded for ALL shells)
  └─ .zshrc      → Zinit plugin manager, completions, atuin integration
       ├─ .zsh_aliases        → ~260 lines of aliases (navigation, docker, git, k8s, dev)
       ├─ .zsh_functions      → ~910 lines (extract, mkcd, fzf wrappers, git helpers)
       ├─ .zsh_functions_lazy → Node/npm/nvm lazy loading
       ├─ .zsh_autoload/      → Autoloaded functions
       └─ .p10k.zsh           → Powerlevel10k prompt theme
```

Key: `.zshenv` runs for every shell invocation (including scripts), `.zshrc` only for interactive sessions. Keep `.zshenv` minimal for fast non-interactive shells.

### Neovim Structure (NvChad + lazy.nvim)

```
nvim/.config/nvim/
  init.lua              → Bootstrap lazy.nvim, load NvChad
  lua/
    chadrc.lua          → NvChad theme and UI overrides
    options.lua         → Vim options (tabs, line numbers, folding)
    mappings.lua        → All keybindings (~20KB)
    plugins/init.lua    → Plugin declarations for lazy.nvim
    configs/            → Per-plugin configuration
      lspconfig.lua     → LSP server setup (Go, Python, Rust, Lua, TS, etc.)
      mason.lua         → Mason LSP installer config
      fzf-lua.lua       → FZF integration
      telescope.lua     → Telescope fuzzy finder
      lazy-lock.json    → Plugin version lock file
```

Neovim depends on system binaries from Brewfile: `fd`, `ripgrep`, `glow`, Node, Python.

### Terminal Emulators

Both Kitty and Ghostty support automatic dark/light theme switching synced with macOS system appearance. Kitty uses `dark-theme.auto.conf` / `light-theme.auto.conf`. Ghostty uses `themes.conf` with a switcher script.

### Cross-Package Dependencies

- **ripgrep**: config at `ripgrep/.config/.ripgreprc`, referenced by `RIPGREP_CONFIG_PATH` in `.zshenv`. Used by both shell (fzf wrappers) and Neovim (telescope/fzf-lua).
- **atuin**: replaces default Ctrl+R history search. Config at `atuin/.config/atuin/config.toml`.
- **Brewfile**: declares LSP servers (gopls, pyright, rust-analyzer, lua-language-server, etc.) that Neovim's Mason/lspconfig expects to find on PATH.

### Key Shell Helpers

These are defined in `zsh/.zsh_aliases` and `zsh/.zsh_functions`:
- `pj` — fuzzy project switcher
- `wtn/wtl/wtr` — git worktree create/list/remove
- `prn` — push + open PR via `gh`
- `gcm` — guided conventional commit
- `fcd/zz/rgi/rgf` — fuzzy navigation and search
- `gt/gta/gts` — Ghostty theme switching
- `cc/cx` — launch Claude Code / Codex

### Scripts Directory

- `scripts/sync.sh` — cross-machine sync (git pull + brew bundle + restow)
- `scripts/health-check.sh` — post-install validation
- `scripts/benchmark.sh` — shell startup timing
- `scripts/wt` — git worktree helper (defaults to `~/repos/skates/` workspace)
- `scripts/mac/` — macOS-specific helpers (dock, audio, dark mode toggles)

## Important Patterns

- **Paths must be portable**: use `$HOME`, never hardcode `/Users/ab`. The installer runs `sed` to fix hardcoded paths.
- **Secrets via direnv**: `.envrc` loads `~/.secrets/github.env`. Never commit secrets.
- **Stow target is always `$HOME`**: package directory structure must mirror the home directory layout (e.g., `kitty/.config/kitty/kitty.conf` → `~/.config/kitty/kitty.conf`).
- **Lazy loading for performance**: Node/npm/nvm are lazy-loaded in `.zsh_functions_lazy` to keep shell startup fast. The benchmark scripts verify startup time.

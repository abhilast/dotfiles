# Architecture

**Analysis Date:** 2026-03-18

## Pattern Overview

**Overall:** Stow-based Configuration Management with Layered Shell + Editor Bootstrap

**Key Characteristics:**
- GNU Stow-managed monorepo: each top-level directory is a package that symlinks into `$HOME`
- Explicit dependency ordering enforced in `install.sh` (git → zsh → nvim → kitty → ghostty → ripgrep → lsd → btop → broot → atuin → go → linearmouse)
- Two-tier shell configuration: `.zshenv` (all shells, minimal) loads before `.zshrc` (interactive only, plugin-heavy)
- Lazy loading throughout: Node.js, conda, kubectl, and editor plugins defer initialization for performance
- Per-tool namespace isolation: each package contains only its own config files, nothing shared across packages

## Layers

**Stow Package Layer:**
- Purpose: Atomic configuration units that independently symlink to `$HOME` without conflicts
- Location: Top-level directories: `git/`, `zsh/`, `nvim/`, `kitty/`, `ghostty/`, `ripgrep/`, `lsd/`, `btop/`, `broot/`, `atuin/`, `go/`, `linearmouse/`, `scripts/`
- Contains: Config files in XDG-compliant directory structure (`.config/`, dotfiles at root of package)
- Depends on: Nothing initially; installed in sequence by `install.sh`
- Used by: System installation via `stow -R`, cross-package references in shell config

**Bootstrap / Entry Point Layer:**
- Purpose: Initialize system on fresh install, validate setup, and manage symlinks
- Location: `install.sh`, `scripts/health-check.sh`, `scripts/sync.sh`
- Contains: Installation orchestration, dependency checking, symlink validation
- Depends on: Homebrew, Git
- Used by: Initial setup and ongoing maintenance

**Shell Environment Layer (.zshenv):**
- Purpose: Minimal environment configuration loaded for ALL zsh invocations (interactive and non-interactive)
- Location: `zsh/.zshenv` (133 lines)
- Contains: Core environment variables, PATH construction, tool config paths (RIPGREP_CONFIG_PATH, EDITOR, VISUAL, LANG)
- Depends on: Homebrew for PATH detection, Ripgrep config
- Used by: Every zsh shell, scripts, and interactive sessions

**Shell Interactive Layer (.zshrc):**
- Purpose: Plugin management and interactive session setup (prompt, completions, history, bindings)
- Location: `zsh/.zshrc` (206 lines)
- Contains: Zinit plugin manager, Powerlevel10k theme, completions, FZF/atuin integration, lazy loaders
- Depends on: `.zshenv`, Zinit, Powerlevel10k, fast-syntax-highlighting, zsh-autosuggestions, atuin, direnv
- Used by: Interactive zsh sessions only

**Shell Function Layer:**
- Purpose: Extensible functions and helpers for common tasks
- Location:
  - `zsh/.zsh_functions` (910 lines): extract, mkcd, up, search, git helpers, project switcher
  - `zsh/.zsh_functions_lazy` (580 lines): Node.js lazy loading (npm, node, npx wrappers)
  - `zsh/.zsh_aliases` (265 lines): 260+ aliases for navigation, docker, git, k8s, dev tools
  - `zsh/.zsh_autoload/`: Autoloaded function modules (docker-helpers, git-helpers)
- Depends on: `.zshrc` sourcing, FZF, Ripgrep, Homebrew bins
- Used by: Interactive shell sessions

**Neovim Configuration Layer:**
- Purpose: Editor configuration with plugin management via lazy.nvim
- Location: `nvim/.config/nvim/`
- Entry: `init.lua` (40 lines) bootstraps lazy.nvim, loads NvChad framework
- Subcomponents:
  - `lua/options.lua` (133 lines): Vim options, tabs, folding, number display
  - `lua/mappings.lua` (212 lines): All keybindings (space-leader navigation)
  - `lua/chadrc.lua` (64 lines): NvChad theme/UI overrides
  - `lua/plugins/init.lua` (573 lines): 30+ plugin declarations with lazy loading specs
  - `lua/configs/`: Per-plugin configuration (lspconfig, mason, telescope, fzf-lua, neo-tree, etc.)
- Depends on: lazy.nvim, NvChad base, Mason LSP installer, Treesitter, Homebrew binaries (fd, ripgrep, glow)
- Used by: Neovim editor instance

**Tool Configuration Layer:**
- Purpose: Minimize startup time by lazy-loading heavy binaries on first use
- Patterns:
  - Node.js: `zsh/.zsh_functions_lazy` defines npm/node/npx functions that unfunction and load NVM on first call
  - Conda: Similar pattern, first conda call loads miniconda shell integration
  - kubectl: First invocation loads completion, then loads bash completions via source
- Depends on: Tool availability on PATH
- Used by: Interactive shell

**Git Configuration Layer:**
- Purpose: Centralized git settings with modular alias/tool config
- Location: `git/.gitconfig` (21 lines) with includes
- Includes: `git/.gitconfig.d/aliases`, `git/.gitconfig.d/tools`
- Contains: User identity, pull strategy (rebase=true), credential manager, Azure DevOps config
- Used by: Git commands globally

**Terminal Theme & Appearance Layer:**
- Purpose: Unified dark/light theme switching across Kitty and Ghostty
- Kitty: `kitty/.config/kitty/dark-theme.auto.conf`, `light-theme.auto.conf`, `no-preference-theme.auto.conf`
- Ghostty: `ghostty/.config/ghostty/themes.conf` with theme switching script
- Used by: Terminal emulators to sync with macOS system appearance

**Utility Scripts Layer:**
- Purpose: Maintenance, health checks, performance profiling, and system helpers
- Location: `scripts/` (18 files)
- Categories:
  - Setup/sync: `install.sh`, `sync.sh`, `health-check.sh`, `backup-configs.sh`
  - Performance profiling: `benchmark.sh`, `profile-zsh-startup.sh`, `zsh-benchmark-advanced.sh`
  - Git helpers: `wt` (git worktree wrapper, defaults to `~/repos/skates/`)
  - Theme management: `ghostty-theme-switcher.sh`
  - macOS system: `scripts/mac/` (7 helpers: dock toggles, audio switching, dark mode, HiDPI fixes)
- Depends on: Bash, standard Unix tools, Homebrew

## Data Flow

**System Bootstrap Flow:**

1. User runs `install.sh`
2. Check macOS (`uname`)
3. Install Homebrew if absent
4. Install GNU Stow
5. Clone dotfiles if needed
6. Install packages from Brewfile (runtime, LSP servers, system tools)
7. Fix hardcoded paths (sed `s|/Users/ab|$HOME|g`)
8. Create `~/.config`, `~/.local/share`, `~/.cache` directories
9. Run Stow in dependency order (git first, then zsh, then others)
10. Install Neovim plugins via `nvim --headless "+Lazy! sync" +qa`
11. Source `.zshrc`

**Shell Startup Flow (Interactive):**

1. Zsh invocation
2. Load `.zshenv` (set PATH, tool variables)
3. If interactive: load `.zshrc`
4. Zinit loads Powerlevel10k (instant prompt)
5. Zinit loads turbo-mode plugins (git, syntax highlighting, autosuggestions, history-substring-search in stages)
6. Source `.zsh_functions`, `.zsh_aliases`
7. Initialize direnv, atuin (Ctrl+R search replacement), zoxide
8. Lazy loaders ready: Node.js, conda, kubectl on first use
9. Shell ready for input

**Editor Startup Flow:**

1. User runs `nvim`
2. `init.lua` bootstraps lazy.nvim
3. lazy.nvim loads NvChad base plugins (non-lazy)
4. lazy.nvim loads custom plugins from `lua/plugins/init.lua` (deferred, event-based, or cmd-based)
5. LSP servers loaded by Mason on demand
6. Treesitter parsers installed on first use of language
7. `mappings.lua` bindings registered
8. `options.lua` Vim settings applied

**Symlink Creation Flow (Stow):**

Each package mirrors home directory structure:
- `git/.gitconfig` → `~/.gitconfig`
- `git/.config/lazygit/config.yml` → `~/.config/lazygit/config.yml`
- `zsh/.zshenv` → `~/.zshenv`
- `nvim/.config/nvim/init.lua` → `~/.config/nvim/init.lua`
- `kitty/.config/kitty/kitty.conf` → `~/.config/kitty/kitty.conf`

Stow conflict detection: `scripts/health-check.sh` finds `*.stow-*` conflict files.

**State Management:**

- **Persistent:** Git state, shell history (atuin), Neovim undo/marks
- **Transient:** Zinit cache (`.cache/zinit`), completion cache (`.zcompdump`, rebuilt 24h)
- **Generated:** NvChad base46 cache, Mason installed tools, Treesitter parsers
- **Secrets:** `.envrc` loads `~/.secrets/github.env` via direnv (never committed)

## Key Abstractions

**Stow Package:**
- Purpose: Represent a logically-grouped set of configuration files that symlink atomically
- Examples: `git/`, `nvim/`, `zsh/`, `kitty/`
- Pattern: Mirror home directory structure; Stow symlinks entire subtree

**Lazy Loader:**
- Purpose: Defer expensive tool initialization until first use
- Examples:
  - Node.js: `npm() { unfunction npm; load NVM; npm "$@" }`
  - Conda: `conda() { unfunction conda; eval conda setup; conda "$@" }`
- Pattern: Function shadows binary name, undefines itself, loads real tool, calls it, future calls use real binary

**Zinit Turbo Plugin:**
- Purpose: Load plugins after prompt appears for perceived speed
- Examples: Wait stages `0a` (git), `0b` (syntax + autosuggestions), `0c` (history), `1` (fzf-tab)
- Pattern: `zinit ice wait'0a' lucid; zinit light <repo>`

**Plugin Spec (lazy.nvim):**
- Purpose: Declarative plugin configuration with lazy loading events/commands/filetypes
- Examples:
  - `event = 'BufWritePre'`: Load conform on save
  - `ft = { "go", "python" }`: Load language-specific plugins on file open
  - `cmd = { "Mason" }`: Load Mason only on `:Mason` command
- Pattern: Tuple of repo URL + opts/config table

**Modular Git Config:**
- Purpose: Keep `.gitconfig` slim, split concerns into `.gitconfig.d/`
- Examples: `aliases` file, `tools` file
- Pattern: `[include] path = ~/.gitconfig.d/aliases`

## Entry Points

**install.sh:**
- Location: `/Users/ab/dotfiles/install.sh`
- Triggers: Manual `./install.sh` on fresh system
- Responsibilities: Homebrew setup, Stow package installation, plugin sync, path fixes

**sync.sh:**
- Location: `/Users/ab/dotfiles/scripts/sync.sh`
- Triggers: Manual `./scripts/sync.sh` for cross-machine sync
- Responsibilities: Git pull, brew bundle, restow all packages

**.zshenv:**
- Location: `~/.zshenv` (symlinked from `zsh/.zshenv`)
- Triggers: Every zsh invocation (login, non-login, scripts)
- Responsibilities: Minimal environment setup (PATH, tool variables)

**.zshrc:**
- Location: `~/.zshrc` (symlinked from `zsh/.zshrc`)
- Triggers: Interactive zsh sessions only
- Responsibilities: Plugin loading, interactive setup, shell options

**init.lua (Neovim):**
- Location: `~/.config/nvim/init.lua` (symlinked from `nvim/.config/nvim/init.lua`)
- Triggers: `nvim` command
- Responsibilities: Bootstrap lazy.nvim, load NvChad, load custom plugins and configs

## Error Handling

**Strategy:** Fail gracefully with warnings, continue initialization

**Patterns:**

1. **Stow Conflicts:** `install.sh` catches `stow` errors, prints warning, continues
2. **Missing Tools:** Shell functions check `command -v` before using, fallback or skip
3. **Plugin Load Failures:** Zinit warns but doesn't block shell startup
4. **Lazy Loader Failure:** E.g., NVM missing doesn't block npm wrapper definition; npm call will fail with missing NVM error
5. **Config Sourcing:** `[[ -f "$file" ]] && source "$file"` guards all optional config sources
6. **Health Check:** `health-check.sh` reports missing deps as ❌ but continues

**No exceptions:** Early `set -e` in scripts means installation stops on error, but running shell startup is fault-tolerant.

## Cross-Cutting Concerns

**Performance:**
- Comments throughout `.zshenv` and `.zshrc` note "PERFORMANCE" optimizations
- Lazy loading defers Node.js, conda, kubectl, Neovim plugins
- Completion cache rebuilt only if > 24h old
- Zinit turbo mode stages plugin loading

**Portability:**
- All paths use `$HOME`, never hardcoded `/Users/ab`
- `install.sh` runs `sed` to fix paths
- `.zshenv` checks for Homebrew path conditionally (Apple Silicon vs Intel)
- Fallbacks for missing tools (e.g., lsd not available → use ls)

**Security:**
- Secrets via direnv `.envrc` loading `~/.secrets/github.env`
- Credential helper set to gcm-core (GitHub credential manager)
- No passwords in committed files

**Reproducibility:**
- `Brewfile` pins package versions
- `nvim/lazy-lock.json` pins plugin versions
- Stow order enforced in `install.sh` ensures consistent symlink setup
- `.zcompdump` regenerated on cache miss for fresh completions

---

*Architecture analysis: 2026-03-18*

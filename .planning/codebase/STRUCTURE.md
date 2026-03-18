# Codebase Structure

**Analysis Date:** 2026-03-18

## Directory Layout

```
dotfiles/                          # Root: GNU Stow repository
├── install.sh                      # Bootstrap script for macOS
├── sync.sh                         # Placeholder (actual: scripts/sync.sh)
├── Brewfile                        # Homebrew package declarations
├── CLAUDE.md                       # Development guidance
├── AGENTS.md                       # Coding style and commit conventions
├── README.md                       # User-facing documentation
│
├── git/                            # Stow package: Git configuration
│   ├── .gitconfig                  # Main git config with includes
│   └── .config/
│       ├── lazygit/config.yml      # LazyGit UI config
│       └── .gitconfig.d/           # Modular git config
│           ├── aliases             # Git command aliases
│           └── tools               # Git tool integrations
│
├── zsh/                            # Stow package: Shell configuration (largest)
│   ├── .zshenv                     # Environment variables (all shells)
│   ├── .zshrc                      # Interactive shell setup (Zinit plugins)
│   ├── .zsh_aliases                # ~260 aliases (nav, docker, git, k8s, dev)
│   ├── .zsh_functions              # ~910 helper functions (extract, mkcd, fcd, git helpers)
│   ├── .zsh_functions_lazy         # ~580 lines: Node.js/npm/conda lazy loading
│   ├── .p10k.zsh                   # Powerlevel10k prompt customization
│   ├── .zsh_autoload/              # Autoloaded function modules
│   │   ├── docker-helpers          # Docker utility functions
│   │   └── git-helpers             # Git utility functions
│   └── README.md
│
├── nvim/                           # Stow package: Neovim (NvChad + lazy.nvim)
│   └── .config/nvim/
│       ├── init.lua                # Bootstrap, load lazy.nvim, NvChad
│       ├── lua/
│       │   ├── options.lua         # Vim settings (tabs, folds, numbers)
│       │   ├── mappings.lua        # All keybindings (~212 lines)
│       │   ├── chadrc.lua          # NvChad theme overrides
│       │   ├── plugins/
│       │   │   └── init.lua        # 30+ plugin declarations (lazy specs)
│       │   └── configs/            # Per-plugin configuration
│       │       ├── lspconfig.lua   # LSP server setup (Go, Python, Rust, Lua, TS, K8s)
│       │       ├── mason.lua       # LSP/formatter/linter installer
│       │       ├── telescope.lua   # Fuzzy finder integration
│       │       ├── fzf-lua.lua     # FZF integration
│       │       ├── neo-tree.lua    # File tree explorer
│       │       ├── conform.lua     # Code formatter
│       │       ├── harpoon.lua     # Quick file navigation
│       │       ├── lazy.lua        # lazy.nvim settings
│       │       ├── kubernetes.lua  # K8s YAML detection
│       │       └── [other configs]
│       ├── lazy-lock.json          # Plugin version lock file
│       └── install scripts...
│
├── kitty/                          # Stow package: Kitty terminal emulator
│   └── .config/kitty/
│       ├── kitty.conf              # Main config
│       ├── dark-theme.auto.conf    # Auto dark theme
│       ├── light-theme.auto.conf   # Auto light theme
│       ├── no-preference-theme.auto.conf
│       ├── macos-shortcuts.conf    # macOS keyboard bindings
│       ├── reading-optimizations.conf
│       ├── diff.conf
│       └── theme files...
│
├── ghostty/                        # Stow package: Ghostty GPU terminal
│   └── .config/ghostty/
│       ├── config                  # Main ghostty config
│       └── themes.conf             # Theme definitions
│
├── ripgrep/                        # Stow package: Ripgrep search tool
│   └── .config/
│       └── .ripgreprc              # Global ripgrep options
│
├── atuin/                          # Stow package: Advanced shell history
│   └── .config/atuin/
│       └── config.toml             # Atuin config
│
├── lsd/                            # Stow package: Modern ls replacement
│   └── .config/lsd/
│       └── config.yaml
│
├── btop/                           # Stow package: System monitor
│   └── .config/btop/
│       └── btoprc
│
├── broot/                          # Stow package: File manager
│   └── .config/broot/
│       ├── launcher/bash/br        # Bash/zsh launcher
│       └── conf.toml
│
├── go/                             # Stow package: Go tooling
│   ├── .config/go/                 # Go workspace config
│   └── revive/                     # Go linter config
│
├── linearmouse/                    # Stow package: Mouse configuration
│   └── .config/linearmouse/
│       └── linearmouse.toml
│
├── scratchpad/                     # Stow package: Scratch workspace
│   └── (user-created content)
│
└── scripts/                        # Utility scripts (not stowed)
    ├── install.sh                  # Master bootstrap script
    ├── sync.sh                     # Cross-machine sync
    ├── health-check.sh             # Validate setup (symlinks, deps)
    ├── benchmark.sh                # Shell startup timing
    ├── profile-zsh-startup.sh      # Detailed startup profiling
    ├── zsh-benchmark-advanced.sh   # Advanced profiling
    ├── ghostty-theme-switcher.sh   # Theme switching automation
    ├── backup-configs.sh           # Config file backup
    ├── migrate-to-zinit.sh         # Plugin manager migration
    ├── test-completion-demo.sh     # Test completions
    ├── wt                          # Git worktree helper (~/repos/skates/ workspace)
    └── mac/                        # macOS-specific helpers
        ├── toggle_dark_mode.sh
        ├── toggle_dock_position.sh
        ├── toggle-dock-visibility.sh
        ├── rc-toggle-dock.sh
        ├── switch_audio_source.sh  # Audio input/output switching
        ├── set_sound_io_studio_display.sh
        └── fix-arzopa-hidpi.sh     # HiDPI fix for Arzopa display

```

## Directory Purposes

**dotfiles/ (root):**
- Purpose: Repository root and stow target specification
- Contains: Bootstrap scripts, Brewfile, metadata (CLAUDE.md, AGENTS.md)
- Key files: `install.sh`, `Brewfile`

**git/:**
- Purpose: Git configuration that applies globally
- Contains: `.gitconfig` (main config with includes) and modular config in `.gitconfig.d/`
- Key files: `.gitconfig` (includes), `lazygit/config.yml` (LazyGit UI)
- Stowed to: `~/.gitconfig`, `~/.config/lazygit/`

**zsh/:**
- Purpose: Complete shell environment (largest package, ~4,800 lines total)
- Contains: Environment setup, shell functions, aliases, completions, prompt theme, plugin config
- Key files:
  - `.zshenv` (133 lines): Minimal env vars, loaded for all shells
  - `.zshrc` (206 lines): Zinit plugin manager, interactive setup
  - `.zsh_functions` (910 lines): Helpers (extract, mkcd, up, fcd, zz, rgi, git-related)
  - `.zsh_aliases` (265 lines): Navigation, docker, git, k8s, dev aliases
  - `.zsh_functions_lazy` (580 lines): npm, node, conda lazy loaders
  - `.p10k.zsh` (1,720 lines): Powerlevel10k prompt
- Stowed to: `~/.zshenv`, `~/.zshrc`, `~/.*`, `~/.zsh_autoload/`
- Performance: Multi-stage Zinit loading, lazy loaders, 24h completion cache

**nvim/:**
- Purpose: Neovim configuration with 30+ plugins (NvChad + lazy.nvim)
- Contains: Lua configs, plugin specs, LSP setup, keybindings, language-specific configs
- Key files:
  - `init.lua` (40 lines): Bootstrap lazy.nvim, load NvChad
  - `lua/options.lua` (133 lines): Vim settings
  - `lua/mappings.lua` (212 lines): Space-leader keybindings
  - `lua/plugins/init.lua` (573 lines): Plugin declarations
  - `lua/configs/lspconfig.lua`: 15+ LSP servers (Go, Python, Rust, Lua, TS, YAML, etc.)
  - `lazy-lock.json`: Plugin version lock
- Stowed to: `~/.config/nvim/`
- Plugins: Treesitter, Telescope, FZF, neo-tree, conform, harpoon, mason, LSP, DAP (debugging), neotest

**kitty/:**
- Purpose: Kitty terminal emulator configuration with auto theme switching
- Contains: Main config, theme variants, macOS keybindings, performance optimizations
- Key files:
  - `kitty.conf` (main config, ~100 lines)
  - `dark-theme.auto.conf`, `light-theme.auto.conf`: macOS dark/light sync
  - `macos-shortcuts.conf`: Keyboard shortcuts for macOS
- Stowed to: `~/.config/kitty/`

**ghostty/:**
- Purpose: Ghostty GPU terminal configuration with theme switching
- Contains: Main config, theme definitions
- Key files: `config`, `themes.conf`
- Stowed to: `~/.config/ghostty/`

**ripgrep/, atuin/, lsd/, btop/, broot/, go/, linearmouse/:**
- Purpose: Individual tool configurations
- Each: Single package directory with `.config/<tool>/` structure or root dotfile
- Stowed to: Respective tool config locations

**scratchpad/:**
- Purpose: User-created scratch workspace (e.g., scripts, notes, test files)
- Stowed to: `~/.scratchpad/`

**scripts/:**
- Purpose: Utility scripts (NOT stowed as a package; manually invoked)
- Contains: 18 files across multiple categories
- Categories:
  - **Setup:** `install.sh`, `sync.sh`, `health-check.sh`
  - **Profiling:** `benchmark.sh`, `profile-zsh-startup.sh`
  - **Git helpers:** `wt` (worktree), other git-related utils
  - **Theme:** `ghostty-theme-switcher.sh`
  - **macOS:** `scripts/mac/` (7 helpers for dock, audio, dark mode, display fixes)
- NOT stowed; run manually via `./scripts/script-name.sh`

## Key File Locations

**Entry Points:**

- `./install.sh`: System bootstrap (Homebrew, Stow, plugins)
- `./scripts/sync.sh`: Cross-machine sync (pull + brew bundle + restow)
- `~/.zshenv` (← `zsh/.zshenv`): Loaded for all shells
- `~/.zshrc` (← `zsh/.zshrc`): Loaded for interactive shells
- `~/.config/nvim/init.lua` (← `nvim/.config/nvim/init.lua`): Neovim entry

**Configuration:**

- `Brewfile`: Homebrew package + cask declarations (runtime, LSP, tools)
- `git/.gitconfig`: Git config with includes to `.gitconfig.d/aliases` and `.gitconfig.d/tools`
- `zsh/.zshenv`: Environment variables (PATH, tool config paths)
- `nvim/.config/nvim/lua/options.lua`: Vim settings (tabs, folding, line numbers)
- `nvim/.config/nvim/lua/chadrc.lua`: NvChad theme overrides

**Core Logic:**

- `zsh/.zsh_functions`: Shell helpers (910 lines of functions)
- `zsh/.zsh_aliases`: Command shortcuts (265 lines of aliases)
- `nvim/.config/nvim/lua/plugins/init.lua`: Plugin specs and lazy loading config (573 lines)
- `nvim/.config/nvim/lua/mappings.lua`: All keybindings (212 lines)

**Testing / Validation:**

- `scripts/health-check.sh`: Verify symlinks, missing deps, ZSH startup time
- `scripts/benchmark.sh`: Quick shell startup timing
- `scripts/profile-zsh-startup.sh`: Detailed startup breakdown

## Naming Conventions

**Files:**

- **Dotfiles (hidden files):** `.zshenv`, `.zshrc`, `.gitconfig`, `.p10k.zsh`
- **Config files:** `kitty.conf`, `config.toml`, `config.yml`, `.ripgreprc`
- **Scripts:** Lowercase with hyphens: `install.sh`, `health-check.sh`, `fix-arzopa-hidpi.sh`
- **Lock files:** `lazy-lock.json` (Neovim plugins)
- **Lua modules:** `init.lua`, `options.lua`, `mappings.lua` (lowercase, snake_case)

**Directories:**

- **Stow packages:** Lowercase single words: `git`, `zsh`, `nvim`, `kitty`
- **XDG standard:** `.config/<tool>/`, `.local/share/`, `.cache/`
- **Modular config:** `.gitconfig.d/`, `.zsh_autoload/`, `lua/configs/`
- **Utilities:** `scripts/`, `scripts/mac/`

## Where to Add New Code

**New Shell Alias:**
- Location: `zsh/.zsh_aliases`
- Format: Single line: `alias <name>="<command>"`
- Section: Organize by category (navigation, git, docker, k8s, dev)
- Example:
  ```bash
  # In "🔧 DEVELOPMENT TOOLS" section
  alias gpt="gh pr create --title"
  ```

**New Shell Function:**
- Location: `zsh/.zsh_functions` (standard functions) or `zsh/.zsh_functions_lazy` (deferred)
- Format: Function definition with error handling, early returns
- Example:
  ```bash
  # PERFORMANCE: New function for widget manipulation
  my_function() {
    [[ $# -eq 0 ]] && { echo "Usage: my_function <arg>"; return 1; }
    # ... logic ...
  }
  ```

**New Autoloaded Function:**
- Location: `zsh/.zsh_autoload/<category-name>` (new file)
- Format: Function definition (no function wrapper needed, file name is function name)
- Result: Automatically sourced on first call

**New Neovim Plugin:**
- Location: `nvim/.config/nvim/lua/plugins/init.lua`
- Format: Add table entry in return table with lazy.nvim spec
- Create config file: `nvim/.config/nvim/lua/configs/<plugin-name>.lua` if needed
- Example:
  ```lua
  {
    "author/plugin-name",
    event = "BufReadPost",  -- or ft = { "filetype" }, or cmd = { "Command" }
    config = function()
      require "configs.plugin-name"
    end,
  },
  ```

**New Tool Package:**
- Create new directory: `<tool-name>/`
- Mirror home structure: `<tool-name>/.config/<tool>/config` or `<tool-name>/.<dotfile>`
- Add to `install.sh` STOW_ORDER array (in appropriate dependency position)
- Add README.md with tool description

**Utilities / Scripts:**
- Location: `scripts/<script-name>.sh` (general) or `scripts/mac/<script-name>.sh` (macOS-specific)
- Header: #!/bin/bash, set -euo pipefail
- Run: `./scripts/<script-name>.sh` (not stowed)

## Special Directories

**~/.cache/zinit/:**
- Purpose: Zinit plugin manager cache
- Generated: Yes (created by Zinit)
- Committed: No
- Rebuild: Manual with `zinit download-self`

**~/.local/share/nvim/:**
- Purpose: Neovim data directory (plugins, LSP servers, undo history, marks)
- Generated: Yes (created by lazy.nvim and Mason)
- Committed: No
- Rebuild: `nvim --headless "+Lazy! sync" +qa` or `:Lazy sync` inside Neovim

**~/.local/share/zinit/:**
- Purpose: Zinit installation and plugin repos
- Generated: Yes (created by Zinit)
- Committed: No
- Rebuild: Automatic on `.zshrc` load if missing

**~/.config/broot/launcher/:**
- Purpose: Generated Broot launcher script
- Generated: Yes (created by `br` init)
- Committed: No
- Rebuild: Run broot initialization from shell

**~/.zcompdump* and ~/.zcompdump.zwc:**
- Purpose: Zsh completion cache
- Generated: Yes
- Committed: No
- Rebuild: Automatically if > 24h old or missing (see `.zshrc` compinit logic)

**~/.cache/ (general):**
- Purpose: Tool caches (fzf colors, completion caches, theme data)
- Committed: No

---

*Structure analysis: 2026-03-18*

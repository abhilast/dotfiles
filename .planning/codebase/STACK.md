# Technology Stack

**Analysis Date:** 2026-03-18

## Languages

**Primary:**
- Shell/Bash - All configuration and scripting. Entry points: `install.sh`, `scripts/*.sh`
- Lua - Neovim configuration. Location: `nvim/.config/nvim/`
- TOML - Configuration files (atuin, revive linter)
- YAML - Kubernetes manifests, Helm charts, cloud config

**Secondary:**
- Go - Primary dev language target (via gopls LSP)
- Python - Secondary dev language target (via pyright LSP)
- TypeScript/JavaScript - Supported via typescript-language-server
- Rust - Supported via rust-analyzer LSP
- Terraform/HCL - Infrastructure as code support via terraformls
- Dockerfile - Container support via dockerls

## Runtime

**Environment:**
- macOS (Apple Silicon and Intel) - Exclusive target OS
- Homebrew - Primary package manager
- Bun - JavaScript runtime/toolkit alternative to Node
- Python (via miniconda) - Package manager via Conda
- Go - Version management via brew
- Rust - Via cargo (`.cargo/env` sourced in `.zshenv`)

**Package Manager:**
- Homebrew - Primary (40+ formulae and casks)
- Lockfile: `Brewfile` (declared dependencies, no lock file generated)
- direnv - Environment variable management (`.envrc` references `~/.secrets/github.env`)

## Frameworks

**Core:**
- NvChad v2.5 - Neovim base configuration framework. Location: `nvim/.config/nvim/`
- lazy.nvim - Neovim plugin manager. Bootstrap: `nvim/.config/nvim/init.lua`
- GNU Stow - Dotfiles symlink manager. Stow order: git → zsh → nvim → kitty → ghostty → ripgrep → lsd → btop → broot → atuin → go → linearmouse

**Terminal Emulators:**
- Kitty - GPU-accelerated terminal emulator. Config: `kitty/.config/kitty/`
- Ghostty - Modern terminal with GPU acceleration. Config: `ghostty/.config/ghostty/`
- Both support auto dark/light theme switching via macOS system appearance

**Shell:**
- Zsh - Default shell
- Powerlevel10k - Theme and prompt. Installed via brew
- Zinit - Plugin manager. Bootstrap in `.zshrc`

**Testing/Debugging:**
- nvim-dap - Neovim debug adapter protocol
- nvim-dap-ui - DAP UI integration
- neotest - Testing framework for Go and Python
- neotest-python - Pytest adapter (uses pipenv detection)
- neotest-go - Go test adapter

**Build/Dev Tools:**
- Mason (williamboman/mason.nvim) - LSP and tool installer for Neovim
- Conform.nvim - Code formatter integration
- Telescope - Fuzzy finder for files, symbols, recent files
- FZF - Fuzzy command-line finder (shell integration)
- fzf-lua - Lua FZF integration for Neovim

## Key Dependencies

**Critical Infrastructure:**
- git - Version control. Configured in `git/.gitconfig`, includes git-credential-manager
- gh - GitHub CLI. Used extensively in shell functions for PR management
- lazygit - Interactive git TUI (aliased in shell)
- git-delta - Syntax-aware git diffs. Configured as pager in `.gitconfig.d/tools`
- difftastic - Structural diffs. Used by git difftool and lazygit

**File Search & Navigation:**
- ripgrep (rg) - Fast grep alternative. Config: `ripgrep/.config/.ripgreprc`, referenced via `RIPGREP_CONFIG_PATH`
- fd - Fast find alternative. Used in FZF_DEFAULT_COMMAND
- fzf - Fuzzy finder for shell (Ctrl+T, Alt+C, Ctrl+R)
- zoxide - Smart cd replacement (zz alias). Lazy loaded
- bat - Cat with syntax highlighting (used in FZF previews)

**Directory & File Management:**
- lsd - Modern ls replacement with icons
- eza - Modern ls alternative (used in FZF previews)
- tree - Directory tree viewer (fallback)
- broot - Interactive directory navigator. Config: `broot/`

**Development Tools:**
- neovim - Editor (primary, aliased as vim, vi, v)
- docker - Containerization with LSP support (dockerls)
- kubernetes-cli (kubectl) - Kubernetes client, lazy loaded in zshrc
- stow - Symlink manager (core infrastructure)
- jq - JSON processor
- curl - HTTP client (used in install.sh)
- wget - Network downloader

**System Monitoring & Utilities:**
- btop - System monitor with config in `btop/.config/btop/`
- hyperfine - Command-line benchmarking (used in `scripts/benchmark.sh`)
- atuin - Shell history database with sync. Config: `atuin/.config/atuin/config.toml`

**LSP Servers (Installed via Brew):**
- gopls - Go language server
- pyright - Python language server
- typescript-language-server - TypeScript/JavaScript
- rust-analyzer - Rust
- lua-language-server - Lua
- swift - Swift/SourceKit-LSP
- jdtls - Java
- kotlin-language-server - Kotlin
- llvm (clangd) - C/C++
- dotnet - Required for csharp-ls (installed separately)

**LSP Servers (Not in Brew, Install Separately):**
- csharp-ls - C# (install: `dotnet tool install --global csharp-ls`)
- intelephense - PHP (install: `npm i -g intelephense`)

**Optional Tools:**
- miniconda - Python environment manager (Conda)
- linearmouse - Mouse configuration tool. Config: `linearmouse/.config/`

## Configuration

**Environment:**
- Homebrew auto-update disabled for performance: `HOMEBREW_AUTO_UPDATE_SECS=86400`, `HOMEBREW_NO_AUTO_UPDATE=1`
- Analytics disabled: `HOMEBREW_NO_ANALYTICS=1`
- SSH auth via 1Password agent: `SSH_AUTH_SOCK=~/.1password/agent.sock`
- Workspace directory: `WORKSPACE=$HOME/Developer/repos`
- FZF colors theme-aware (light/dark based on macOS appearance)
- Secrets loaded via direnv: `.envrc` loads `~/.secrets/github.env`

**Build/Runtime:**
- PATH construction optimized in `.zshenv` with deduplication (`typeset -U PATH`)
- Go binaries: `$GOPATH/bin` added to PATH (caches go env call)
- Cargo: `.cargo/env` sourced if exists
- Bun: `$HOME/.bun/bin` added to PATH
- Scripts: `$HOME/dotfiles/scripts` added to PATH

**Neovim:**
- Init location: `nvim/.config/nvim/init.lua`
- Options: `nvim/.config/nvim/lua/options.lua`
- Keybindings: `nvim/.config/nvim/lua/mappings.lua` (~20KB)
- Plugin specs: `nvim/.config/nvim/lua/plugins/init.lua`
- LSP config: `nvim/.config/nvim/lua/configs/lspconfig.lua`
- Mason config: `nvim/.config/nvim/lua/configs/mason.lua`
- Theme overrides: `nvim/.config/nvim/lua/chadrc.lua`
- lazy-lock.json: `nvim/.config/nvim/lazy-lock.json` (plugin version lock file)

**Shell Configuration:**
- `.zshenv` - Environment variables (all shells)
- `.zshrc` - Interactive shell config (bash alternatives in Brewfile notes)
- `.zsh_aliases` - ~260 lines of aliases
- `.zsh_functions` - ~910 lines of helper functions
- `.zsh_functions_lazy` - Node/npm/nvm lazy loading
- `.zsh_autoload/` - Autoloaded function directory

**Git Configuration:**
- `git/.gitconfig` - User info, credential helper (git-credential-manager)
- `git/.gitconfig.d/aliases` - Custom git aliases
- `git/.gitconfig.d/tools` - Tool configuration (delta, difftastic, nvimdiff)

**Terminal Configuration:**
- Kitty: `kitty/.config/kitty/kitty.conf`, theme switching via conf files
- Ghostty: `ghostty/.config/ghostty/config`, theme switching via script

## Platform Requirements

**Development:**
- macOS (tested on Apple Silicon and Intel)
- Homebrew for package management
- Bash or Zsh shell
- curl and wget for downloads
- Git for version control

**Production/Deployment Targets:**
- Docker containers (dockerls support)
- Kubernetes clusters (kubectl, helm, kubernetes LSP)
- Terraform (terraformls support)
- Cloud platforms (AWS implied by Granted integration, Azure suggested by git credential manager config)

---

*Stack analysis: 2026-03-18*

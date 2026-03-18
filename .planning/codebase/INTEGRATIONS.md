# External Integrations

**Analysis Date:** 2026-03-18

## APIs & External Services

**GitHub:**
- Service: GitHub (repository hosting and code management)
- SDK/Client: `gh` (GitHub CLI)
- Usage: PR creation, issue management, git operations
- Environment: `~/.secrets/github.env` (loaded via `.envrc`)
- Integration points:
  - `zsh/.zsh_functions` - GitHub helpers including `prn` (push + open PR via gh)
  - `git/.gitconfig` - Git credential manager configured
  - References in commit conventions (AGENTS.md references)

**Homebrew:**
- Service: Homebrew package repository API
- Usage: Package installation and updates
- Environment: `HOMEBREW_NO_AUTO_UPDATE=1`, `HOMEBREW_AUTO_UPDATE_SECS=86400`
- Configuration: `Brewfile` with 40+ dependencies

**Atuin History Sync:**
- Service: Atuin cloud (https://api.atuin.sh)
- Usage: Shell history database synchronization
- Config: `atuin/.config/atuin/config.toml`
- Settings:
  - `sync_address = "https://api.atuin.sh"`
  - `sync_frequency = "15m"` (syncs every 15 minutes if logged in)
  - `auto_sync = true`
  - Network timeouts: 5s connect, 30s overall
- Security: Secrets filtering enabled, filters AWS keys, tokens, passwords

**Kubernetes/Cloud Resources:**
- Service: Kubernetes API servers (referenced in YAML configs)
- LSP Integration: yamlls with Kubernetes schema (yannh/kubernetes-json-schema)
- Reference schema: `https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.30.0-standalone-strict/all.json`
- Kubectl integration: kubernetes-cli package
- Detection: `nvim/.config/nvim/lua/configs/kubernetes.lua` auto-detects K8s YAML

**Infrastructure APIs:**
- Terraform: terraformls language server support
- Docker: dockerls language server, docker CLI integration
- Helm: helm_ls language server, vim-helm plugin
- Azure: Git credential manager configured for `dev.azure.com` with `useHttpPath = true`

## Data Storage

**Databases:**
- MySQL: LSP support via sqls. Connection via env var `DB_MYSQL_DSN`
  - Driver: mysql
  - Location in config: `nvim/.config/nvim/lua/configs/lspconfig.lua` lines 111-115
- PostgreSQL: LSP support via sqls. Connection via env var `DB_POSTGRES_DSN`
  - Driver: postgresql
  - Location in config: `nvim/.config/nvim/lua/configs/lspconfig.lua` lines 116-120

**Shell History Storage:**
- Atuin: Local SQLite database at `~/.local/share/atuin/history.db`
- Managed by atuin package
- Max history: 100,000 commands

**File Storage:**
- Local filesystem only
- Neovim cache: `~/.config/nvim/` (lazy.nvim, mason packages)
- Neovim data: `~/.local/share/nvim/`

**Caching:**
- None detected beyond Neovim plugin manager caching

## Authentication & Identity

**Git Authentication:**
- Provider: Git Credential Manager
- Cask: `git-credential-manager`
- Config location: `git/.gitconfig` lines 16-20
- Supports:
  - GitHub HTTPS authentication
  - Azure DevOps (`dev.azure.com` with `useHttpPath = true`)
- SSH: 1Password SSH agent via `SSH_AUTH_SOCK=~/.1password/agent.sock`

**Cloud Access Management:**
- Granted: IAM role assumption tool
- Zsh completion: `/Users/ab/.granted/zsh_autocomplete/assume/` and `/Users/ab/.granted/zsh_autocomplete/granted/`
- Shell alias: `alias assume=". assume"` (sources assume script)
- Use case: AWS/cloud role assumption for CLI operations

**1Password Integration:**
- SSH agent: `SSH_AUTH_SOCK=~/.1password/agent.sock`
- Purpose: SSH key management for git/GitHub operations

## Monitoring & Observability

**Error Tracking:**
- Not detected in configuration

**Logs:**
- Atuin history database: `~/.local/share/atuin/history.db`
- Neovim logs: Via Mason/plugin debug output
- Shell logging: History captured by atuin with filtering

**Performance Metrics:**
- Benchmarking: `scripts/benchmark.sh` for shell startup timing
- Profiling: `scripts/profile-zsh-startup.sh` for detailed startup analysis
- Tools: hyperfine for command benchmarking

## CI/CD & Deployment

**Hosting:**
- macOS (development environment only)
- Docker containers (via docker LSP)
- Kubernetes clusters (via kubectl, helm-ls)

**CI Pipeline:**
- Not detected (this is a dotfiles repo, not a project with CI)
- GitHub CLI integration available for workflow triggers via `gh` CLI

**Deployment Tools:**
- Stow: Symlink-based deployment to `$HOME`
- Docker: Container support
- Kubernetes: Manifest support via kubectl
- Terraform: Infrastructure as code via terraformls

## Environment Configuration

**Required env vars:**
- `EDITOR=nvim` - Default editor
- `VISUAL=nvim` - Visual editor
- `SSH_AUTH_SOCK=~/.1password/agent.sock` - 1Password SSH
- `WORKSPACE=$HOME/Developer/repos` - Default workspace
- `RIPGREP_CONFIG_PATH=$HOME/.config/.ripgreprc` - Ripgrep config location
- `LESS="-R"` - Pager for git diffs (delta color support)
- `LANG=en_US.UTF-8` - Locale
- `LC_ALL=en_US.UTF-8` - Locale

**Database connection env vars (optional):**
- `DB_MYSQL_DSN` - MySQL connection string for sqls LSP
- `DB_POSTGRES_DSN` - PostgreSQL connection string for sqls LSP
- Format: `host=127.0.0.1 port=5432 user=postgres password=PASSWORD dbname=name sslmode=disable`

**Secrets location:**
- `.envrc` loads `~/.secrets/github.env`
- Never committed to repository
- Loaded by direnv on directory entry

## Webhooks & Callbacks

**Incoming:**
- Not detected

**Outgoing:**
- Atuin: Sends shell history to `https://api.atuin.sh` (sync endpoint)
- GitHub: PR operations via `gh` CLI (webhook-adjacent, API-driven)

## Package Registries

**Homebrew:**
- Brewfile references taps implicitly (default Homebrew taps)
- Casks: font-jetbrains-mono-nerd-font (from homebrew-cask)

**NPM (for optional installs):**
- intelephense - PHP LSP (install: `npm i -g intelephense`)

**.NET (for optional installs):**
- csharp-ls - C# LSP (install: `dotnet tool install --global csharp-ls`)

## Third-Party CLI Integrations

**FZF Integration:**
- Library: fzf with native C extension (`telescope-fzf-native.nvim`)
- Build: `make` required for fzf-native compilation
- Usage:
  - Shell: Ctrl+T (file), Alt+C (directory), Ctrl+R (history via atuin)
  - Neovim: Multiple search commands

**Treesitter:**
- Parsers: vim, lua, vimdoc, html, css, go, gosum, gomod, python, bash, yaml, json, hcl, terraform, dockerfile, toml, helm
- Repository: GitHub (nvim-treesitter/nvim-treesitter)
- Auto-update: Via lazy.nvim

**LSP Configuration:**
- Schema repository: schemastore.nvim for JSON schemas
- Kubernetes schema: yannh/kubernetes-json-schema (GitHub)
- YAML companion: yaml-companion.nvim for schema detection

---

*Integration audit: 2026-03-18*

# Architecture Research

**Domain:** chezmoi-based dotfiles management (Stow migration)
**Researched:** 2026-03-18
**Confidence:** HIGH

## Standard Architecture

### System Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    chezmoi Source State                       │
│  (~/.local/share/chezmoi/ = this git repo)                   │
├─────────────────────────────────────────────────────────────┤
│  ┌───────────┐  ┌───────────┐  ┌───────────┐               │
│  │ Templates │  │   Exact   │  │  Scripts  │               │
│  │ (.tmpl)   │  │  Files    │  │ (run_*)   │               │
│  └─────┬─────┘  └─────┬─────┘  └─────┬─────┘               │
│        │              │              │                       │
├────────┴──────────────┴──────────────┴───────────────────────┤
│                    chezmoi Apply Engine                       │
│  (template rendering, file diff, permission setting)         │
├─────────────────────────────────────────────────────────────┤
│  ┌──────────┐  ┌──────────┐  ┌──────────┐                   │
│  │ 1Password│  │ chezmoi  │  │ Machine  │                   │
│  │   CLI    │  │  .toml   │  │  Facts   │                   │
│  └──────────┘  └──────────┘  └──────────┘                   │
│                    Data Sources                               │
└─────────────────────────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────────────────────────┐
│                    Target State ($HOME)                       │
│  ~/.zshrc, ~/.config/nvim/, ~/.config/ghostty/, etc.         │
└─────────────────────────────────────────────────────────────┘
```

### Component Responsibilities

| Component | Responsibility | Implementation |
|-----------|----------------|----------------|
| Source State | Canonical config files with chezmoi naming prefixes | Git repo = chezmoi source dir |
| Templates (.tmpl) | Machine-specific config generation | Go templates with chezmoi data |
| Exact Files | Files managed verbatim (no templating needed) | Standard files with `dot_` prefix |
| Run Scripts | Bootstrap, package install, post-apply hooks | Shell scripts with `run_once_`/`run_onchange_` prefixes |
| chezmoi.toml | Per-machine config (hostname, email, preferences) | Generated from `.chezmoi.toml.tmpl` on init |
| 1Password CLI | Secret resolution at apply time | `onepasswordRead` in templates |
| .chezmoiignore | Platform/machine-specific file exclusion | Templated ignore patterns |

## Recommended Project Structure

### Source Directory Layout

```
~/.local/share/chezmoi/          # = git repo root
├── .chezmoi.toml.tmpl           # Config template (prompts on init)
├── .chezmoiignore               # Templated ignore rules
├── .chezmoiversion               # Minimum chezmoi version
├── .chezmoiscripts/             # Lifecycle scripts
│   ├── run_once_before_01-install-homebrew.sh
│   ├── run_onchange_before_02-brew-bundle.sh.tmpl
│   ├── run_once_before_03-setup-1password.sh
│   ├── run_once_after_10-neovim-plugins.sh
│   └── run_once_after_11-set-default-shell.sh
├── .chezmoitemplates/           # Reusable template partials
│   ├── 1password-item.tmpl      # Helper for 1Password lookups
│   └── brew-path.tmpl           # Homebrew path detection
├── Brewfile                     # Homebrew dependencies (tracked for run_onchange_)
├── dot_zshenv.tmpl              # → ~/.zshenv (templated for paths)
├── dot_zshrc                    # → ~/.zshrc
├── dot_zsh_aliases              # → ~/.zsh_aliases
├── dot_zsh_functions            # → ~/.zsh_functions
├── dot_zsh_functions_lazy       # → ~/.zsh_functions_lazy
├── dot_zsh_autoload/            # → ~/.zsh_autoload/
├── dot_p10k.zsh                 # → ~/.p10k.zsh
├── dot_gitconfig.tmpl           # → ~/.gitconfig (templated for email/name)
├── dot_gitignore_global         # → ~/.gitignore_global
├── private_dot_config/          # → ~/.config/ (private = 0700)
│   ├── nvim/                    # Neovim config tree
│   │   ├── init.lua
│   │   └── lua/
│   │       ├── chadrc.lua
│   │       ├── options.lua
│   │       ├── mappings.lua
│   │       └── plugins/
│   ├── kitty/
│   │   ├── kitty.conf.tmpl      # Templated for theme paths
│   │   ├── dark-theme.auto.conf
│   │   └── light-theme.auto.conf
│   ├── ghostty/
│   │   ├── config.tmpl           # Templated for theme
│   │   └── themes.conf
│   ├── ripgrep/
│   │   └── dot_ripgreprc        # → ~/.config/.ripgreprc
│   ├── lsd/
│   ├── btop/
│   ├── broot/
│   └── atuin/
│       └── config.toml
└── scripts/                     # Utility scripts (not chezmoi-managed)
    ├── mac/
    └── benchmark.sh
```

### Structure Rationale

- **`.chezmoiscripts/`:** Centralized lifecycle scripts, numbered for ordering. `before_` runs pre-apply, `after_` runs post-apply.
- **`dot_` prefix:** Maps to dotfiles in `$HOME`. chezmoi strips prefix and adds `.` on apply.
- **`private_dot_config/`:** The `private_` prefix sets directory permissions to 0700, `dot_` maps to `.config`.
- **`.tmpl` suffix:** Files processed through Go template engine. Only use when machine-specific differences exist.
- **`Brewfile` at root:** Tracked by git so `run_onchange_` can detect changes and re-run `brew bundle`.

## Architectural Patterns

### Pattern 1: Templated Config with Machine Data

**What:** Use `.chezmoi.toml.tmpl` to prompt for machine-specific data on first init, then reference it in templates.

**When to use:** Any config that varies between machines (email, paths, hostname-specific settings).

**Example:**
```
{{- /* .chezmoi.toml.tmpl */ -}}
{{- $email := promptStringOnce . "email" "Email address" -}}
{{- $isWork := promptBoolOnce . "isWork" "Is this a work machine" -}}

[data]
  email = {{ $email | quote }}
  isWork = {{ $isWork }}
```

Then in `dot_gitconfig.tmpl`:
```
[user]
  email = {{ .email }}
  name = "Abhilash"
```

### Pattern 2: Run Script Ordering

**What:** Use numbered prefixes within `run_once_`/`run_onchange_` scripts for deterministic execution order.

**When to use:** Bootstrap scripts that have dependencies (Homebrew before packages, packages before config).

**Example:**
```
run_once_before_01-install-homebrew.sh    # First: ensure Homebrew exists
run_onchange_before_02-brew-bundle.sh.tmpl # Second: install packages (re-runs on Brewfile change)
run_once_before_03-setup-1password.sh     # Third: configure op CLI
run_once_after_10-neovim-plugins.sh       # After apply: sync Neovim plugins
```

### Pattern 3: 1Password Secret Injection

**What:** Reference secrets via `onepasswordRead` in templates — secrets are resolved at apply time, never stored in repo.

**When to use:** Any secret (API tokens, credentials, SSH keys).

**Example:**
```
{{- /* dot_zshenv.tmpl */ -}}
export GITHUB_TOKEN="{{ onepasswordRead "op://Private/GitHub Token/credential" }}"
```

**Trade-offs:** Requires 1Password CLI authenticated at apply time. First apply on new machine needs `op` setup first.

### Pattern 4: Templated .chezmoiignore

**What:** Use Go templates in `.chezmoiignore` to conditionally exclude files per OS/machine.

**When to use:** Files that only apply to specific machines or configurations.

**Example:**
```
{{- if ne .chezmoi.os "darwin" }}
.config/kitty/
.config/ghostty/
scripts/mac/
{{- end }}
```

## Data Flow

### Bootstrap Flow (Fresh Machine)

```
chezmoi init --apply <github-user>
    ↓
Clone repo → ~/.local/share/chezmoi/
    ↓
Process .chezmoi.toml.tmpl → prompt for machine data
    ↓
Run run_once_before_* scripts (install Homebrew, brew bundle, 1Password setup)
    ↓
Apply source state → render templates → write to $HOME
    ↓
Run run_once_after_* scripts (Neovim plugins, default shell)
    ↓
Machine fully configured ✓
```

### Sync Flow (Existing Machine)

```
chezmoi update
    ↓
git pull (source state)
    ↓
Diff source vs target
    ↓
Run run_onchange_* if content changed (e.g., Brewfile updated)
    ↓
Apply changes to $HOME
    ↓
Machine updated ✓
```

### Secret Resolution Flow

```
Template contains {{ onepasswordRead "op://..." }}
    ↓
chezmoi calls `op read "op://..."`
    ↓
1Password CLI uses biometric auth (Touch ID on Mac)
    ↓
Secret injected into rendered file
    ↓
File written to $HOME (secret in target, not in source)
```

## Migration Order from Stow

Suggested build order for migrating each Stow package:

| Order | Package | Complexity | Notes |
|-------|---------|-----------|-------|
| 1 | git | Low | Simple dotfiles, template for email |
| 2 | zsh (.zshenv) | Medium | Template for Homebrew path, env vars |
| 3 | zsh (.zshrc + deps) | Medium | Aliases, functions, lazy loaders — mostly exact copies |
| 4 | ripgrep | Low | Single config file |
| 5 | atuin | Low | Single TOML config |
| 6 | lsd, btop, broot | Low | Simple configs |
| 7 | nvim | Medium | Large directory tree, needs exact_ for clean management |
| 8 | kitty | Medium | Template for theme switching paths |
| 9 | ghostty | Medium | Template for theme switching |
| 10 | go, linearmouse | Low | Minimal configs |
| 11 | Bootstrap scripts | High | Replace install.sh, sync.sh, health-check.sh with run scripts |
| 12 | 1Password secrets | High | Replace direnv + ~/.secrets/ with onepasswordRead |

**Key insight:** Migrate simple packages first to build confidence with chezmoi conventions, save complex scripting and secret management for last.

## Anti-Patterns

### Anti-Pattern 1: Over-Templating

**What people do:** Make every file a `.tmpl` even when there are no machine differences.
**Why it's wrong:** Templates are harder to read and edit. Go template syntax in shell scripts is noisy.
**Do this instead:** Only use `.tmpl` when the file genuinely varies between machines. Most configs are identical across your Macs.

### Anti-Pattern 2: Secrets in Data Files

**What people do:** Put secrets in `.chezmoidata.yaml` or `.chezmoi.toml`.
**Why it's wrong:** These files are in the git repo.
**Do this instead:** Always use `onepasswordRead` in templates for secrets.

### Anti-Pattern 3: Using exact_ Everywhere

**What people do:** Apply `exact_` prefix to every directory.
**Why it's wrong:** `exact_` deletes files not in chezmoi source. If a tool creates files in a managed directory (e.g., Neovim's lazy-lock.json), they get deleted on every apply.
**Do this instead:** Only use `exact_` on directories you fully control and want to be pristine.

### Anti-Pattern 4: Monolithic Run Scripts

**What people do:** Put everything in one big `run_once_install.sh`.
**Why it's wrong:** If any step fails, the whole script is marked as "run" and won't retry. Can't selectively re-run parts.
**Do this instead:** Split into numbered, focused scripts. Each handles one concern.

## Sources

- chezmoi official documentation (chezmoi.io)
- chezmoi GitHub repository and examples
- Community dotfiles repos using chezmoi patterns

---
*Architecture research for: chezmoi dotfiles management*
*Researched: 2026-03-18*

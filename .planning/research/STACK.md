# Stack Research: Chezmoi Dotfiles Management

**Research Date:** 2026-03-18
**Domain:** chezmoi-based dotfiles management on macOS with 1Password CLI

## Core Tool

| Component | Recommendation | Version | Confidence |
|-----------|---------------|---------|------------|
| chezmoi | Primary dotfiles manager | 2.70.0+ (via Homebrew) | High |
| 1Password CLI | Secret management | v2 (`op`) | High |
| Go templates | Config templating | Built into chezmoi | High |

### chezmoi (v2.70.0+)

**Why:** Purpose-built dotfiles manager with templating, secret management, and cross-machine sync built in. Replaces GNU Stow + install.sh + sync.sh + health-check.sh with a single tool.

**Install:** `brew install chezmoi`

**Key features used:**
- Go template engine for machine-specific configs
- Native 1Password CLI v2 integration via `onepasswordRead` template function
- `run_once_` and `run_onchange_` scripts for automation
- `chezmoi add` for easy onboarding of new configs
- `chezmoi update` for cross-machine sync (pull + apply)
- `chezmoi init --apply` for one-command bootstrap

### 1Password CLI v2

**Why:** Native chezmoi integration, biometric auth on macOS, no session tokens to manage.

**Critical finding:** The old `eval $(op signin)` pattern from CLI v1 is broken in v2. Use biometric auth instead — chezmoi handles this natively.

**Template function:** `onepasswordRead` reads secrets directly from 1Password vaults in templates.

**Example:**
```
{{ onepasswordRead "op://Private/GitHub Token/credential" }}
```

## File Naming Conventions

chezmoi uses filename prefixes to control behavior:

| Prefix | Meaning | Example |
|--------|---------|---------|
| `dot_` | Creates dotfile (`.` prefix) | `dot_zshrc` → `.zshrc` |
| `private_` | Sets file permissions to 0600 | `private_dot_ssh/` |
| `exact_` | Removes files not in source | `exact_dot_config/` |
| `run_once_` | Run script once (tracked by hash) | `run_once_install-homebrew.sh` |
| `run_onchange_` | Run when content changes | `run_onchange_brew-bundle.sh.tmpl` |
| `before_` / `after_` | Script ordering | `run_once_before_install-homebrew.sh` |
| `.tmpl` | Process as Go template | `dot_zshenv.tmpl` |
| `modify_` | Modify existing file | `modify_dot_zshrc` |
| `create_` | Create only if missing | `create_dot_gitconfig.tmpl` |
| `symlink_` | Create symlink | `symlink_dot_config/` |
| `encrypted_` | Encrypted file (age/gpg) | `encrypted_private_dot_secrets` |

## Special Directories & Files

| Path | Purpose |
|------|---------|
| `.chezmoiscripts/` | Scripts that run during apply |
| `.chezmoitemplates/` | Reusable template partials |
| `.chezmoiignore` | Files to ignore (supports templates) |
| `.chezmoiexternal.toml` | External file/archive downloads |
| `.chezmoi.toml.tmpl` | Config template (prompts on init) |
| `.chezmoiroot` | Override source directory root |
| `.chezmoiversion` | Minimum chezmoi version requirement |

## Bootstrap Pattern

**Recommended order for run scripts:**

```
run_once_before_01-install-homebrew.sh       # Install Homebrew if missing
run_onchange_before_02-brew-bundle.sh.tmpl   # Install/update Brew packages (re-runs on Brewfile change)
run_once_before_03-setup-1password-cli.sh    # Ensure op CLI is configured
run_once_after_10-setup-neovim.sh            # Headless Neovim plugin sync
run_once_after_11-set-default-shell.sh       # Set zsh as default shell
```

**Key insight:** Use `run_onchange_` (not `run_once_`) for Brewfile — it re-runs when Brewfile contents change, keeping packages in sync.

## chezmoi.toml.tmpl Configuration

```toml
{{- $hostname := .chezmoi.hostname -}}
{{- $email := promptStringOnce . "email" "Email address" -}}

[data]
  hostname = {{ $hostname | quote }}
  email = {{ $email | quote }}

[onepassword]
  command = "op"
  prompt = true

[diff]
  pager = "delta"
```

Uses `promptStringOnce` — prompts on first `chezmoi init`, stores answer for subsequent runs.

## What NOT to Use

| Avoid | Why | Use Instead |
|-------|-----|-------------|
| `run_once_` for Brewfile | Won't re-run when Brewfile changes | `run_onchange_` with Brewfile hash |
| `op signin` session tokens | Broken in CLI v2, fragile | Biometric auth (native on macOS) |
| Symlinks for config files | Defeats chezmoi's source-state model | Let chezmoi manage files directly |
| Secrets in source repo | Security risk even if .gitignored | 1Password `onepasswordRead` templates |
| `.chezmoiexternal` for git repos | Fragile, use Homebrew for tools | Brewfile for CLI tools |
| `exact_` on large directories | Deletes untracked files aggressively | Use selectively on dirs you fully control |

## Confidence Assessment

| Area | Confidence | Notes |
|------|-----------|-------|
| chezmoi core features | High | Well-documented, stable API |
| 1Password integration | High | First-class support in chezmoi |
| Run script patterns | High | Well-established conventions |
| Template engine | High | Standard Go templates |
| Migration from Stow | Medium | Domain-specific, fewer references |

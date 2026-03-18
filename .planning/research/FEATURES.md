# Feature Research

**Domain:** Dotfiles management — chezmoi migration from GNU Stow, multi-Mac, 1Password
**Researched:** 2026-03-18
**Confidence:** HIGH (chezmoi official docs + multiple community sources)

---

## Feature Landscape

### Table Stakes (Users Expect These)

Features that must exist or the migration from Stow is pointless — these are the baseline capabilities that justify switching.

| Feature | Why Expected | Complexity | Notes |
|---------|--------------|------------|-------|
| One-command bootstrap on fresh Mac | Core value proposition: `chezmoi init --apply github.com/user/dotfiles` replaces manual `install.sh` orchestration | MEDIUM | chezmoi handles clone + template render + apply in one shot; 1Password must be pre-installed or handled by `hooks.read-source-state.pre` |
| All 12 existing packages managed (git, zsh, nvim, kitty, ghostty, etc.) | Regression-free migration — nothing currently working can break | MEDIUM | Stow's directory-mirror convention maps cleanly to chezmoi source state; bulk conversion is mechanical |
| Homebrew bundle via `run_onchange_` script | Replaces manual `brew bundle` step; Brewfile changes trigger reinstall automatically | LOW | Embed Brewfile as heredoc in the script; chezmoi reruns when script content changes |
| Neovim plugin sync via `run_once_` script | Replaces manual `nvim --headless "+Lazy! sync" +qa` step | LOW | `run_once_` fires on first bootstrap; `run_onchange_` fires if the plugin list changes |
| 1Password CLI secret injection via templates | Replaces fragile direnv + `~/.secrets/github.env` — secrets never touch the repo | MEDIUM | Uses `onepasswordRead` template function; `op` must be authenticated before `chezmoi apply`; caching means `op` is called once per unique reference per run |
| `chezmoi update` for cross-machine sync | Replaces manual `git pull + brew bundle + stow -R` — one command pulls and applies | LOW | Built-in: `chezmoi update` = git pull + apply; with `autoPush = true` local edits push automatically |
| Machine-specific config via Go templates | Replaces zero built-in Stow capability — handles Apple Silicon vs Intel PATH differences, hostname-specific git config | MEDIUM | Template variables: `.chezmoi.hostname`, `.chezmoi.arch`, `.chezmoi.os`; custom variables via `.chezmoidata.yaml` or `chezmoi.toml` `[data]` section |
| `chezmoi add` / `chezmoi edit` workflow | Simpler than understanding Stow's directory-mirror convention for onboarding new configs | LOW | `chezmoi add ~/.config/foo` copies file into source state; `chezmoi edit` opens in editor and optionally auto-applies |
| Source state is a plain directory | Files are readable/editable without understanding chezmoi internals, unlike Stow's symlink indirection | LOW | chezmoi copies files to destination (no symlinks); fundamental design property |
| Shell startup performance preserved | Current benchmark target <200ms; lazy-loading patterns in `.zsh_functions_lazy` must survive migration | LOW | chezmoi does not affect runtime behavior of shell configs — it only manages how files land on disk |

### Differentiators (Competitive Advantage over Stow)

| Feature | Value Proposition | Complexity | Notes |
|---------|-------------------|------------|-------|
| `run_once_before_` hook for 1Password bootstrap | Solves the chicken-and-egg problem: installs `op` CLI before templates that read from 1Password are rendered | HIGH | `hooks.read-source-state.pre` in `chezmoi.toml` runs before source state is read on every `chezmoi init` |
| Go template engine for per-machine config | Single source of truth; no separate files per machine; `.chezmoi.arch` detects Apple Silicon vs Intel for Homebrew prefix | MEDIUM | `.chezmoidata.yaml` for static data; `chezmoi.toml [data]` for machine-local variables NOT committed to repo |
| `run_onchange_` for Homebrew triggered by content hash | Brewfile changes automatically trigger `brew bundle` on next `chezmoi update` | LOW | Embed Brewfile inline in the script for content hash tracking |
| `git.autoCommit` + `git.autoPush` | Every `chezmoi edit` or `chezmoi add` automatically commits and pushes — keeps all Macs in sync without manual git ops | LOW | Enable only after confirming no plaintext secrets in source state |
| `.chezmoiexternal.yaml` for external assets | Download fonts, binaries, or plugin archives directly — declares desired state | HIGH | `refreshPeriod` controls re-download; useful for Nerd Fonts |
| Non-symlink destination files | Files exist as real files on disk — editors and macOS preferences work without surprise | LOW | Fundamental property; relevant for Ghostty and Kitty configs |
| `chezmoi verify` / `chezmoi diff` | Shows exactly what chezmoi would change before applying — audit drift | LOW | No Stow equivalent |
| `chezmoi doctor` | Validates environment: checks `op`, `git`, template prerequisites | LOW | Replaces `health-check.sh` |

### Anti-Features (Commonly Requested, Often Problematic)

| Feature | Why Problematic | Alternative |
|---------|-----------------|-------------|
| Encrypting secrets with age/gpg in repo | Invites brute-force; misconfigured template leaks everything; key rotation painful | 1Password `onepasswordRead` — secrets never touch the repo |
| `autoPush = true` from day one | If a secret accidentally lands in source state, it pushes to GitHub immediately | Enable after migration is stable and `chezmoi diff` confirms no secrets |
| `.chezmoiexternal` for everything | Large/frequent externals make every `chezmoi apply` slow and network-dependent | Use `run_onchange_` for package managers; reserve `.chezmoiexternal` for static assets |
| Storing shell history in chezmoi | Every change requires explicit commit; fights tools like atuin | Atuin manages history; chezmoi manages atuin's config only |
| Running `chezmoi apply` in cron | Silent changes mid-session can break running processes | Use `chezmoi update` explicitly |
| CI/CD pipeline for dotfiles | High setup cost for marginal gain; dotfiles are deeply personal | Manual `chezmoi verify` before pushing |

---

## Feature Dependencies

```
1Password CLI (op installed + authenticated)
    └──required by──> Secret injection via onepasswordRead templates
                          └──required by──> git config (user.email from 1Password)
                          └──required by──> atuin config (sync key from 1Password)

hooks.read-source-state.pre (installs op)
    └──enables──> Secret injection (solves chicken-and-egg)
    └──required before──> chezmoi init --apply completing on fresh Mac

run_onchange_before_install-homebrew-packages.sh
    └──required before──> run_once_after_setup-neovim-plugins.sh
        (Neovim must be installed via Homebrew before plugin sync)

chezmoi.toml [data] (machine-local, NOT committed)
    └──consumed by──> Go templates for machine-specific config

git.autoCommit = true
    └──required by──> git.autoPush = true
    └──conflicts with──> plaintext secrets in source state
```

---

## Feature Prioritization Matrix

| Feature | User Value | Implementation Cost | Priority |
|---------|------------|---------------------|----------|
| All 12 packages migrated to chezmoi source state | HIGH | MEDIUM | P1 |
| `run_onchange_` Homebrew script | HIGH | LOW | P1 |
| `run_once_` Neovim plugin sync | HIGH | LOW | P1 |
| 1Password secret injection (git config) | HIGH | MEDIUM | P1 |
| `hooks.read-source-state.pre` for op bootstrap | HIGH | MEDIUM | P1 |
| Apple Silicon / Intel arch template | HIGH | LOW | P1 |
| `chezmoi update` replaces `sync.sh` | HIGH | LOW | P1 |
| `autoCommit = true` | MEDIUM | LOW | P2 |
| Machine-role variables in `chezmoi.toml` | MEDIUM | LOW | P2 |
| `autoPush = true` | MEDIUM | LOW | P2 |
| `.chezmoiexternal` for fonts | LOW | MEDIUM | P3 |
| `chezmoi doctor` as health-check replacement | LOW | LOW | P3 |

---

## Competitor Feature Analysis

| Feature | Existing Stow Setup | YADM | chezmoi |
|---------|---------------------|------|---------|
| One-command bootstrap | No (`install.sh` manual) | `yadm clone` (partial) | `chezmoi init --apply` (full) |
| Secret management | direnv + flat files | External only | Native 1Password template functions |
| Machine-specific config | None | Alternate files per hostname | Go templates with `.chezmoi.*` variables |
| Dependency ordering | Manual in `install.sh` | None | `run_before_` / `run_after_` naming |
| Detecting config drift | None | `yadm diff` | `chezmoi diff` / `chezmoi verify` |
| File destination type | Symlinks | Symlinks | Real files (copies) |
| Adding new configs | Must understand Stow mirror | `yadm add` | `chezmoi add` |
| Cross-machine sync | Manual `sync.sh` | `yadm pull` | `chezmoi update` + optional `autoPush` |

---

## Sources

- chezmoi official documentation (chezmoi.io) — HIGH confidence
- chezmoi 1Password integration docs — HIGH confidence
- chezmoi run scripts documentation — HIGH confidence
- chezmoi hooks documentation — HIGH confidence
- Community real-world migration patterns — MEDIUM confidence

---
*Feature research for: chezmoi dotfiles migration, multi-Mac + 1Password*
*Researched: 2026-03-18*

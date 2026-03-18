# Dotfiles Chezmoi Migration

## What This Is

A complete migration of an existing GNU Stow-managed dotfiles monorepo to chezmoi. The goal is a single-command bootstrap (`chezmoi init --apply`) that takes a fresh Mac from zero to fully configured — Homebrew packages, shell environment, Neovim, terminal emulators, secrets from 1Password, and theme switching — with no manual steps.

## Core Value

One command on a fresh Mac produces a fully configured development environment, synced across multiple Macs, with zero manual intervention.

## Requirements

### Validated

<!-- Existing capabilities inferred from current codebase -->

- ✓ ZSH configuration chain (.zshenv → .zshrc → aliases/functions/lazy loaders) — existing
- ✓ Neovim setup with NvChad + lazy.nvim plugin management — existing
- ✓ Kitty and Ghostty terminal emulator configs — existing
- ✓ Ripgrep, lsd, btop, broot, atuin tool configs — existing
- ✓ Git configuration with delta diff viewer — existing
- ✓ Homebrew dependency declaration via Brewfile — existing
- ✓ Dark/light theme switching for terminal emulators — existing
- ✓ ~260 shell aliases and ~910 lines of shell functions — existing
- ✓ Lazy loading for Node/npm/nvm for fast shell startup — existing

### Active

- [ ] chezmoi source directory structure replacing Stow packages
- [ ] One-command bootstrap via `chezmoi init --apply`
- [ ] 1Password CLI integration for secret management (replacing direnv + ~/.secrets/)
- [ ] chezmoi `run_once` scripts for Homebrew bundle install
- [ ] chezmoi `run_once` scripts for Neovim plugin sync
- [ ] Template-driven configs for machine-specific differences across Macs
- [ ] Automatic sync across multiple Macs via `chezmoi update`
- [ ] Dark/light theme switching preserved in chezmoi structure
- [ ] Easy onboarding of new configs via `chezmoi add`
- [ ] Shell startup performance maintained (lazy loading preserved)

### Out of Scope

- Linux support — all Macs, no cross-OS templating needed
- Incremental migration — clean break, not running Stow alongside chezmoi
- Custom chezmoi plugins or extensions — stick to built-in features
- CI/CD pipeline for dotfiles — manual sync is fine

## Context

**Current state:** 12 Stow packages (git, zsh, nvim, kitty, ghostty, ripgrep, lsd, btop, broot, atuin, go, linearmouse) managed by GNU Stow with manual install.sh orchestration, health-check.sh validation, and sync.sh for cross-machine sync. Secrets loaded via direnv from ~/.secrets/github.env.

**Pain points driving migration:**
- Bootstrap requires running install.sh which manually orchestrates stow commands in dependency order
- Syncing across machines requires manual pull + brew bundle + restow
- Secret management is fragile (direnv + flat files in ~/.secrets/)
- Adding new configs requires understanding Stow's directory mirroring convention
- Theme switching is handled by custom scripts outside the Stow paradigm
- No built-in templating for machine-specific config differences

**Chezmoi advantages for this use case:**
- Built-in templating with Go templates (machine-specific configs)
- Native 1Password integration via `onepasswordRead` template function
- `run_once_` / `run_onchange_` scripts replace install.sh, sync.sh, health-check.sh
- `chezmoi add` is simpler than understanding Stow directory layout
- `chezmoi update` handles pull + apply in one command
- Source state is a regular directory (no symlink indirection)

**Key reference:** Current Stow package dependency order: git → zsh → nvim → kitty → ghostty → ripgrep → lsd → btop → broot → atuin → go → linearmouse

## Constraints

- **Target OS**: macOS only (Apple Silicon and Intel Macs)
- **Secret provider**: 1Password CLI (`op`) — must be installed before secrets can be resolved
- **Shell startup**: Must maintain fast startup (<200ms) — lazy loading patterns must be preserved
- **Existing functionality**: All current configs must work identically after migration — no regressions
- **Git history**: Clean break in new chezmoi structure, but old repo history preserved (same repo, restructured)

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Clean break over incremental migration | Avoids dual-tool complexity, chezmoi idioms are different enough that incremental would be messy | — Pending |
| 1Password CLI over age encryption | Already using 1Password, native chezmoi integration, no key management overhead | — Pending |
| chezmoi run_once scripts for Homebrew | Eliminates separate install.sh, keeps package management in same tool | — Pending |
| Same repo, restructured | Preserves git history context, avoids orphan repo | — Pending |

---
*Last updated: 2026-03-18 after initialization*

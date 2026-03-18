# Project Research Summary

**Project:** Migrate dotfiles from GNU Stow to chezmoi
**Domain:** Dotfiles management — chezmoi + 1Password CLI on macOS
**Researched:** 2026-03-18
**Confidence:** HIGH

## Executive Summary

This project migrates a mature GNU Stow dotfiles repo (12 packages, ~260 aliases, ~910 lines of shell functions, NvChad/Neovim, Kitty, Ghostty) to chezmoi. The migration is well-justified: chezmoi replaces a custom stack of `install.sh`, `sync.sh`, and `health-check.sh` with purpose-built primitives — `run_once_`/`run_onchange_` scripts, Go templates for machine-specific config, and native 1Password CLI integration. The current Stow setup has zero secret management (relying on direnv + `~/.secrets/` files) and no machine-specific templating. chezmoi solves both problems cleanly.

The recommended approach is an incremental migration ordered by complexity: start with simple dotfiles (git config, ripgrep, atuin) to build familiarity with chezmoi naming conventions, then migrate larger config trees (zsh, Neovim), and save the highest-risk work — bootstrap scripts and 1Password secret injection — for last. The critical architectural prerequisite is removing all Stow symlinks before chezmoi takes over, and the critical bootstrap dependency is ensuring the `op` CLI is installed before any template containing `onepasswordRead` is evaluated.

The primary risk is the chicken-and-egg problem on fresh machine bootstrap: 1Password templates are evaluated during `chezmoi apply`, but `op` must be installed first. The solution is `hooks.read-source-state.pre` in `.chezmoi.toml.tmpl`, which installs `op` before source state is read. A secondary risk is accidentally using `run_once_` for the Brewfile (packages silently not installing on existing machines) — use `run_onchange_` instead. Both risks have clear, tested prevention strategies.

## Key Findings

### Recommended Stack

chezmoi v2.70.0+ (via Homebrew) is the clear choice: it has a first-class 1Password CLI v2 integration, a built-in Go template engine, `run_once_`/`run_onchange_` script primitives, and a single bootstrap command (`chezmoi init --apply`). There is no meaningful alternative — YADM lacks templating depth and has no native secret management. The 1Password CLI v2 biometric auth model (Touch ID) replaces the fragile `eval $(op signin)` session token pattern from v1 and requires no manual session management.

**Core technologies:**
- **chezmoi v2.70.0+**: Primary dotfiles manager — replaces Stow + install.sh + sync.sh + health-check.sh with a single tool
- **1Password CLI v2 (`op`)**: Secret management — native chezmoi integration via `onepasswordRead`, biometric auth, no session tokens
- **Go templates (.tmpl)**: Machine-specific config — built into chezmoi, handles Apple Silicon vs Intel paths, per-machine email/identity

### Expected Features

**Must have (table stakes / P1):**
- All 12 existing packages migrated without regression
- `chezmoi init --apply <github-user>` as one-command fresh machine bootstrap
- `run_onchange_` Homebrew script that re-runs when Brewfile changes
- `run_once_` Neovim plugin sync (headless `Lazy! sync`)
- 1Password secret injection for git config and any API tokens
- `hooks.read-source-state.pre` to install `op` before templates evaluate
- Apple Silicon vs Intel Homebrew path via `.chezmoi.arch` template variable
- `chezmoi update` replacing `sync.sh`

**Should have (P2 — differentiators over current setup):**
- `git.autoCommit = true` so `chezmoi edit` auto-commits (enable after confirming no secrets in source)
- `git.autoPush = true` for zero-friction cross-machine sync
- Machine-role variables in `chezmoi.toml` (work vs personal, primary vs secondary)

**Defer to v2+:**
- `.chezmoiexternal` for Nerd Fonts or other binary assets
- `chezmoi doctor` as formal `health-check.sh` replacement (low ROI)

### Architecture Approach

chezmoi treats `~/.local/share/chezmoi/` as the canonical source state (a plain git repo). On `chezmoi apply`, it renders `.tmpl` files through Go templates (pulling in data from `chezmoi.toml`, 1Password, and machine facts), diffs source vs target state, and writes real files (not symlinks) to `$HOME`. Run scripts in `.chezmoiscripts/` execute at defined lifecycle points — `before_` scripts run before file application, `after_` scripts run after. Numbered prefixes (`01-`, `02-`) enforce deterministic ordering within each lifecycle phase.

**Major components:**
1. **Source state (git repo)** — canonical config files with chezmoi prefix conventions (`dot_`, `private_`, `exact_`, `.tmpl`)
2. **`.chezmoi.toml.tmpl`** — per-machine config generated on first init via `promptStringOnce`/`promptBoolOnce`; stored locally, not committed
3. **`.chezmoiscripts/`** — numbered lifecycle scripts: Homebrew install, brew bundle, 1Password setup, Neovim sync, default shell
4. **Go templates** — machine-specific rendering; `onepasswordRead` for secrets, `.chezmoi.arch`/`.chezmoi.hostname` for machine facts
5. **chezmoi Apply Engine** — diffs source vs target, renders templates, sets permissions, executes run scripts

### Critical Pitfalls

1. **1Password templates evaluated before `op` is installed** — use `hooks.read-source-state.pre` to install `op` before any source state is read; this is CRITICAL and blocks fresh machine bootstrap if missed
2. **`run_once_` for Brewfile silently stops re-running** — always use `run_onchange_` for Brewfile; embed contents as heredoc so content hash changes trigger re-runs
3. **Stow symlinks left in place during migration** — run `stow -D <package>` for all packages before touching the repo structure; dangling symlinks cause `chezmoi apply` to fail with confusing errors
4. **Script filename attribute order is strict and silent** — correct order is `run_` + (`once_`|`onchange_`) + (`before_`|`after_`) + `name.sh`; wrong order silently treats script as a regular file; verify with `chezmoi managed --include=scripts`
5. **Direct file editing muscle memory** — `~/.zshrc` is now a copy, not a symlink; direct edits are overwritten on next `chezmoi apply`; add `alias ce='chezmoi edit'` and use `chezmoi diff` before applying

## Implications for Roadmap

Based on research, suggested phase structure:

### Phase 1: Pre-Migration Safety
**Rationale:** Must happen before any repo restructuring. Stow symlinks and the migration are mutually exclusive. A backup branch is cheap insurance.
**Delivers:** Clean slate — no Stow symlinks, current state preserved on backup branch, ability to roll back
**Addresses:** All existing packages accounted for before chezmoi takes over
**Avoids:** Pitfall #3 (symlink conflicts), Pitfall #10 (no backup)

### Phase 2: chezmoi Foundation and Initial Config
**Rationale:** Establish chezmoi conventions and verify the tool works before migrating content. Bootstrap structure must exist before any packages are added.
**Delivers:** Working chezmoi repo with `.chezmoi.toml.tmpl`, `.chezmoiversion`, `.chezmoiignore`, and 2-3 simple packages (git, ripgrep, atuin) migrated to build confidence
**Uses:** `dot_` prefix, `private_dot_config/`, `.tmpl` suffix, `promptStringOnce`/`promptBoolOnce`
**Avoids:** Pitfall #4 (missing `.chezmoi.toml.tmpl`), Pitfall #6 (filename order)

### Phase 3: ZSH and Shell Config Migration
**Rationale:** ZSH is the highest-dependency config (other tools reference `$PATH` and env set here). Migrate after chezmoi conventions are established but before terminal emulators that depend on shell environment.
**Delivers:** `.zshenv.tmpl` (with Apple Silicon/Intel Homebrew path), `.zshrc`, `.zsh_aliases`, `.zsh_functions`, `.zsh_functions_lazy`, `.p10k.zsh` all managed by chezmoi
**Implements:** Pattern 1 (templated config with machine data) for Homebrew path detection
**Avoids:** Pitfall #9 (hardcoded Homebrew path), Pitfall #5 (edit workflow — add `ce` alias here)

### Phase 4: Terminal Emulators and Remaining Configs
**Rationale:** Kitty, Ghostty, lsd, btop, broot configs are self-contained. Migrate after shell to avoid breaking the environment used during migration.
**Delivers:** All remaining non-bootstrapped configs in chezmoi (nvim, kitty, ghostty, lsd, btop, broot, go, linearmouse)
**Uses:** `.tmpl` suffix selectively (kitty/ghostty theme paths), `exact_` avoided for nvim (lazy-lock.json)
**Avoids:** Pitfall #8 (`exact_` deleting lazy-lock.json and Mason binaries)

### Phase 5: Bootstrap Scripts
**Rationale:** Scripts replace `install.sh`, `sync.sh`, and `health-check.sh`. Must come after all config is migrated so scripts can be tested against the full source state. This is the highest-complexity phase.
**Delivers:** `.chezmoiscripts/` with numbered Homebrew, brew bundle, Neovim, and default-shell scripts; `chezmoi init --apply` works end-to-end on a fresh machine
**Uses:** `run_once_before_`, `run_onchange_before_`, `run_once_after_` with numeric ordering
**Avoids:** Pitfall #2 (`run_onchange_` for Brewfile), Pitfall #4 (monolithic scripts — split into focused numbered scripts)

### Phase 6: 1Password Secret Integration
**Rationale:** Secret injection requires working bootstrap scripts (Phase 5) and a verified source state with no plaintext secrets. Left last to avoid accidental secret commits during earlier phases.
**Delivers:** `onepasswordRead` templates for git config email/signing, any API tokens; `hooks.read-source-state.pre` for `op` bootstrap on fresh machines
**Implements:** Pattern 3 (1Password secret injection), data flow: Touch ID → `op read` → template rendering → target file
**Avoids:** Pitfall #1 (critical: `op` bootstrap order), Pitfall #7 (multiple 1Password accounts — use vault-qualified paths `op://Personal/...`)

### Phase 7: Sync Automation and Workflow Polish
**Rationale:** Enable auto-commit/push only after confirming no secrets in source state. This is a quality-of-life phase, not load-bearing.
**Delivers:** `git.autoCommit = true`, `git.autoPush = true` in chezmoi config; `ce` alias documented; `chezmoi diff` workflow established; `chezmoi update` replaces `sync.sh`
**Addresses:** P2 features (autoCommit, autoPush, machine-role variables)
**Avoids:** Anti-feature of enabling autoPush before source state is clean

### Phase Ordering Rationale

- Symlink removal must precede all repo restructuring — it's a hard dependency with no workaround
- Simple packages before complex ones — chezmoi prefix conventions have a learning curve; mistakes on git config are cheaper than mistakes on Neovim's 900-file tree
- Bootstrap scripts before secret injection — secrets require `run_once_before_` for `op` installation, which is itself a bootstrap script
- Secret injection last — reduces the window where plaintext credentials could accidentally land in source state
- Auto-push last — once enabled, any accidental secret commit immediately propagates to GitHub

### Research Flags

Phases likely needing deeper research during planning:
- **Phase 5 (Bootstrap Scripts):** The `hooks.read-source-state.pre` mechanism has limited community examples; the exact `.chezmoi.toml.tmpl` hook syntax should be verified against current chezmoi docs before implementation
- **Phase 6 (1Password Integration):** Multiple-account handling (`op://Personal/` vs `op://work/`) is environment-specific and needs to be mapped to actual vault names before templating

Phases with standard patterns (skip research-phase):
- **Phase 2 (chezmoi Foundation):** Well-documented, `promptStringOnce` and `dot_` prefix conventions are stable
- **Phase 3 (ZSH Migration):** Mechanical file rename + `.tmpl` for arch detection; established pattern
- **Phase 4 (Terminal Configs):** Mechanical migration; `exact_` avoidance is documented

## Confidence Assessment

| Area | Confidence | Notes |
|------|------------|-------|
| Stack | HIGH | chezmoi official docs, 1Password integration docs — stable APIs |
| Features | HIGH | Official docs + community migration patterns; P1/P2/P3 split is well-grounded |
| Architecture | HIGH | chezmoi docs are authoritative; source directory layout is deterministic |
| Pitfalls | HIGH | Multiple sources corroborate; critical pitfalls (#1, #2, #3) are widely documented migration hazards |

**Overall confidence:** HIGH

### Gaps to Address

- **`hooks.read-source-state.pre` exact syntax**: The hook mechanism is documented but sparse on real-world examples. Validate against current chezmoi.io docs before Phase 5 implementation.
- **1Password vault naming**: `onepasswordRead` paths need actual vault names (`op://Private/...` vs `op://Personal/...`). Inventory existing 1Password items and vault names before Phase 6.
- **Neovim `exact_` scope**: `lazy-lock.json` lives in `~/.config/nvim/` and is managed by lazy.nvim. The migration must confirm whether any `exact_` usage on the nvim tree would delete it, and scope `exact_` carefully to subdirectories only.
- **Migration from existing machines**: The phased migration plan assumes the primary Mac is the migration machine. The plan for getting the second Mac onto chezmoi (after bootstrap scripts exist) needs explicit sequencing.

## Sources

### Primary (HIGH confidence)
- chezmoi.io official documentation — core features, naming conventions, template functions, hooks
- chezmoi 1Password integration docs — `onepasswordRead`, CLI v2 auth model
- chezmoi run scripts documentation — `run_once_`, `run_onchange_`, `before_`/`after_` lifecycle
- 1Password CLI v2 documentation — biometric auth, `op read`, vault path syntax

### Secondary (MEDIUM confidence)
- Community dotfiles repos using chezmoi patterns — real-world source directory layouts
- Community blog posts on Stow-to-chezmoi migration — migration ordering and gotchas
- chezmoi GitHub issues — common migration problems (exact_ misuse, run_once_ vs run_onchange_)

---
*Research completed: 2026-03-18*
*Ready for roadmap: yes*

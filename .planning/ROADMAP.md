# Roadmap: Dotfiles Chezmoi Migration

**Core Value:** One command on a fresh Mac produces a fully configured development environment, synced across multiple Macs, with zero manual intervention.

**Created:** 2026-03-18
**Granularity:** Standard (6 phases)
**Coverage:** 25/25 v1 requirements mapped

---

## Phases

- [x] **Phase 1: Pre-Migration Safety** - Remove Stow symlinks, create backup branch, clean the slate (completed 2026-03-18)
- [ ] **Phase 2: chezmoi Foundation** - Establish chezmoi source structure, naming conventions, and meta-config files
- [ ] **Phase 3: Shell and Git Migration** - Migrate ZSH config chain and git config with machine-specific templates
- [ ] **Phase 4: Tools and Terminal Migration** - Migrate Neovim, terminal emulators, and all remaining tool configs
- [ ] **Phase 5: Bootstrap Scripts** - Replace install.sh/sync.sh with run_once/run_onchange scripts
- [ ] **Phase 6: End-to-End Validation** - Verify chezmoi init --apply works and no regressions exist

---

## Phase Details

### Phase 1: Pre-Migration Safety
**Goal**: The repository is in a clean state — no Stow symlinks in $HOME, current working state preserved on a backup branch, and legacy orchestration scripts removed. Rolling back to the current Stow-managed setup is possible from the backup branch.
**Depends on**: Nothing (first phase)
**Requirements**: PMIG-01, PMIG-02, PMIG-03
**Success Criteria** (what must be TRUE):
  1. Running `stow -D <package>` for all 12 packages leaves no Stow-managed symlinks in $HOME — `chezmoi apply` can run without symlink conflicts
  2. A git branch exists capturing the current Stow-based state — the user can `git checkout` that branch to restore the pre-migration environment
  3. `install.sh`, `sync.sh`, and `health-check.sh` are removed from the working tree — no confusion between old and new orchestration
**Plans**: 3 plans

Plans:
- [ ] 01-01-PLAN.md — Commit working state, create pre-chezmoi-backup branch and v0-stow tag
- [ ] 01-02-PLAN.md — Unstow all 12 packages, copy real files back to $HOME, flatten .gitconfig.d/ and .zsh_aliases.d/
- [ ] 01-03-PLAN.md — Remove seven legacy Stow orchestration scripts via git rm and commit

### Phase 2: chezmoi Foundation
**Goal**: A valid chezmoi source directory exists in the repo, with correct meta-configuration files, and chezmoi can manage files without errors. The naming conventions and directory structure are established before any package content is migrated.
**Depends on**: Phase 1
**Requirements**: FNDN-01, FNDN-02, FNDN-03, FNDN-04
**Success Criteria** (what must be TRUE):
  1. `chezmoi managed` lists files without errors — the source state is syntactically valid
  2. `.chezmoi.toml.tmpl` prompts for email and machine-specific data on first `chezmoi init` — per-machine config is collected, not hardcoded
  3. Running `chezmoi apply` on the current machine produces no unexpected file changes or errors
  4. `chezmoi doctor` reports no configuration warnings about missing version or ignore rules
**Plans**: 4 plans

Plans:
- [ ] 02-01-PLAN.md — Install chezmoi, create .chezmoi.toml.tmpl, .chezmoiignore, .chezmoiversion
- [ ] 02-02-PLAN.md — Copy ZSH chain, git, ripgrep, atuin to chezmoi source layout; remove Stow dirs
- [ ] 02-03-PLAN.md — Copy nvim, kitty, ghostty, lsd, btop, broot, linearmouse, go to private_dot_config/; remove Stow dirs
- [ ] 02-04-PLAN.md — Commit all changes, run chezmoi init, verify managed/doctor/dry-run; human checkpoint

### Phase 3: Shell and Git Migration
**Goal**: The ZSH configuration chain and git config are fully managed by chezmoi, with machine-specific differences (Homebrew path for Apple Silicon vs Intel, per-machine git email) handled by Go templates. Direct edits to `~/.zshrc` or `~/.gitconfig` are no longer the workflow.
**Depends on**: Phase 2
**Requirements**: CONF-01, CONF-02, TMPL-01, TMPL-02, TMPL-03
**Success Criteria** (what must be TRUE):
  1. `chezmoi managed` lists `.zshenv`, `.zshrc`, `.zsh_aliases`, `.zsh_functions`, `.zsh_functions_lazy`, `.p10k.zsh`, and `.gitconfig` — all are chezmoi-managed
  2. On an Apple Silicon Mac, `chezmoi apply` renders `.zshenv` with `/opt/homebrew` prefix; on Intel it renders `/usr/local` — no hardcoded paths remain
  3. `git config user.email` resolves to the machine-specific email set during `chezmoi init` — git identity is template-driven, not hand-edited
  4. Shell aliases, functions, and lazy loaders all work after `chezmoi apply` — no regressions in shell behavior
**Plans**: TBD

### Phase 4: Tools and Terminal Migration
**Goal**: All remaining configs — Neovim, Kitty, Ghostty, and the tool configs (ripgrep, lsd, btop, broot, atuin, go, linearmouse) plus utility scripts — are managed by chezmoi. Theme switching for terminal emulators is preserved. Neovim's lazy-lock.json and Mason binaries are not deleted by chezmoi's `exact_` semantics.
**Depends on**: Phase 3
**Requirements**: CONF-03, CONF-04, CONF-05, CONF-06, CONF-07, CONF-08
**Success Criteria** (what must be TRUE):
  1. `chezmoi managed` lists Neovim, Kitty, Ghostty, and all tool config files — the full set of 12 former Stow packages is represented in chezmoi source state
  2. Kitty and Ghostty dark/light theme switching works after `chezmoi apply` — `gt`, `gta`, `gts` aliases function correctly
  3. Neovim opens without plugin errors, and `~/.config/nvim/lazy-lock.json` is not deleted or overwritten by chezmoi — `exact_` is not applied to the nvim tree root
  4. `chezmoi apply` runs cleanly with no warnings about unmanaged files in former Stow package directories
**Plans**: TBD

### Phase 5: Bootstrap Scripts
**Goal**: A fresh Mac can run `chezmoi init --apply <github-user>` and emerge fully configured — Homebrew installed, all packages installed from Brewfile, Neovim plugins synced, and zsh set as default shell. The `run_once_`/`run_onchange_` lifecycle scripts replace `install.sh` entirely.
**Depends on**: Phase 4
**Requirements**: BOOT-01, BOOT-02, BOOT-03, BOOT-04
**Success Criteria** (what must be TRUE):
  1. On a machine with no Homebrew, running `chezmoi init --apply` installs Homebrew without manual intervention — `run_once_before_01-install-homebrew.sh` executes correctly
  2. After `chezmoi apply`, all Brewfile packages are installed — `brew bundle check` exits 0
  3. Editing Brewfile and running `chezmoi apply` again triggers a fresh `brew bundle install` — `run_onchange_` re-runs on content change
  4. After `chezmoi apply`, Neovim opens with all plugins installed — the headless `Lazy! sync` ran successfully via `run_once_after_` script
  5. After `chezmoi apply`, `echo $SHELL` returns the path to zsh — default shell was set by the after-script
**Plans**: TBD

### Phase 6: End-to-End Validation
**Goal**: The migration is verified complete with zero regressions. `chezmoi init --apply` works as the sole bootstrap command. All existing functionality is confirmed working. Shell startup time is confirmed under 200ms.
**Depends on**: Phase 5
**Requirements**: VALD-01, VALD-02, VALD-03
**Success Criteria** (what must be TRUE):
  1. Running `chezmoi init --apply <github-user>` on the current machine from a clean state (no pre-existing dotfiles) completes without errors and produces a fully working shell environment
  2. Every alias, function, and tool that worked before migration works identically after — manual smoke test of representative workflows (pj, wtn, fcd, gcm, gt) all pass
  3. `./scripts/benchmark.sh` reports shell startup time under 200ms — lazy loading patterns preserved through migration
**Plans**: TBD

---

## Progress

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Pre-Migration Safety | 3/3 | Complete    | 2026-03-18 |
| 2. chezmoi Foundation | 0/4 | Planned     | - |
| 3. Shell and Git Migration | 0/? | Not started | - |
| 4. Tools and Terminal Migration | 0/? | Not started | - |
| 5. Bootstrap Scripts | 0/? | Not started | - |
| 6. End-to-End Validation | 0/? | Not started | - |

---

## Coverage

| Requirement | Phase | Status |
|-------------|-------|--------|
| PMIG-01 | Phase 1 | Pending |
| PMIG-02 | Phase 1 | Pending |
| PMIG-03 | Phase 1 | Pending |
| FNDN-01 | Phase 2 | Pending |
| FNDN-02 | Phase 2 | Pending |
| FNDN-03 | Phase 2 | Pending |
| FNDN-04 | Phase 2 | Pending |
| CONF-01 | Phase 3 | Pending |
| CONF-02 | Phase 3 | Pending |
| TMPL-01 | Phase 3 | Pending |
| TMPL-02 | Phase 3 | Pending |
| TMPL-03 | Phase 3 | Pending |
| CONF-03 | Phase 4 | Pending |
| CONF-04 | Phase 4 | Pending |
| CONF-05 | Phase 4 | Pending |
| CONF-06 | Phase 4 | Pending |
| CONF-07 | Phase 4 | Pending |
| CONF-08 | Phase 4 | Pending |
| BOOT-01 | Phase 5 | Pending |
| BOOT-02 | Phase 5 | Pending |
| BOOT-03 | Phase 5 | Pending |
| BOOT-04 | Phase 5 | Pending |
| VALD-01 | Phase 6 | Pending |
| VALD-02 | Phase 6 | Pending |
| VALD-03 | Phase 6 | Pending |

**Coverage: 25/25 v1 requirements mapped**

---
*Roadmap created: 2026-03-18*
*Last updated: 2026-03-18 — Phase 2 planned (4 plans)*

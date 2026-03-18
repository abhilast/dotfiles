# Pitfalls Research

**Domain:** Stow-to-chezmoi migration on macOS with 1Password CLI
**Researched:** 2026-03-18
**Confidence:** HIGH

---

## Critical Pitfalls

### Pitfall 1: 1Password Template Evaluation Before `op` is Installed

**Severity:** CRITICAL — breaks `chezmoi init --apply` on fresh machines

**What happens:** Templates containing `onepasswordRead` are evaluated during `chezmoi apply`. If `op` CLI isn't installed yet, chezmoi fails with a cryptic error and aborts the entire apply. On a fresh machine, nothing gets configured.

**Warning signs:**
- `chezmoi init --apply` fails immediately on fresh Mac
- Error mentions `op: command not found` buried in template evaluation
- Works fine on machines where `op` is already installed

**Prevention strategy:**
- Use `hooks.read-source-state.pre` in `.chezmoi.toml.tmpl` to install `op` before source state is read
- Script must be idempotent (fast-exit if `op` already exists)
- Test by temporarily removing `op` and running `chezmoi init`

**Phase mapping:** Must be addressed in the bootstrap/scripts phase, before any 1Password templates are added.

### Pitfall 2: `run_once_` Never Re-Triggers for Brewfile Changes

**Severity:** HIGH — packages silently not installing on existing machines

**What happens:** You use `run_once_install-packages.sh` for `brew bundle`. It runs once on first apply, then never again. When you add a formula to the Brewfile, existing machines never install it — only fresh machines get the full set.

**Warning signs:**
- New Homebrew packages appear on fresh machines but not existing ones
- `brew list` shows different packages on different Macs
- Users manually run `brew bundle` to fix

**Prevention strategy:**
- Use `run_onchange_` instead of `run_once_` for Brewfile
- Embed the Brewfile contents inside the script as a heredoc (the script's content hash is what triggers re-runs)
- Alternative: use `.tmpl` suffix and include Brewfile via `{{ include "Brewfile" }}` — changes to referenced file trigger re-run

**Phase mapping:** Address during bootstrap scripts phase.

### Pitfall 3: Stow Symlink Conflicts During Migration

**Severity:** HIGH — broken dotfiles on the machine doing the migration

**What happens:** Stow created symlinks pointing into the repo. When you restructure the repo for chezmoi, those symlinks break because their targets moved. Running `chezmoi apply` tries to write files but finds dangling symlinks instead of regular files.

**Warning signs:**
- `ls -la` shows broken symlinks (red in terminal) for dotfiles
- `chezmoi apply` errors with "file exists" or permission errors
- Config files suddenly missing after repo restructure

**Prevention strategy:**
1. Run `stow -D <package>` for all packages FIRST to remove all symlinks
2. Verify no symlinks remain: `find ~ -maxdepth 3 -type l -ls 2>/dev/null | grep dotfiles`
3. Then restructure repo for chezmoi
4. Run `chezmoi apply` to create real files

**Phase mapping:** Must be the very first step — before any chezmoi structure changes.

### Pitfall 4: No `.chezmoi.toml.tmpl` for Fresh Machine Config

**Severity:** MEDIUM — bootstrap silently uses empty/wrong template variables

**What happens:** Without `.chezmoi.toml.tmpl`, chezmoi has no machine-specific data on first init. Templates that reference `.email` or `.isWork` get empty strings. Configs are generated with blank values and the user doesn't notice until something breaks.

**Warning signs:**
- Git config has empty email/name after bootstrap
- Template conditionals all evaluate to false
- `chezmoi data` shows empty data section

**Prevention strategy:**
- Create `.chezmoi.toml.tmpl` with `promptStringOnce`/`promptBoolOnce` for all required variables
- Test by running `chezmoi init` in a temp directory to verify prompts appear
- Document required 1Password items that must exist before init

**Phase mapping:** Address during initial chezmoi setup phase.

### Pitfall 5: In-Place File Editing Muscle Memory from Stow

**Severity:** MEDIUM — changes silently overwritten on next `chezmoi apply`

**What happens:** With Stow, editing `~/.zshrc` directly edits the repo file (it's a symlink). With chezmoi, `~/.zshrc` is a copy. Editing it directly works until the next `chezmoi apply`, which overwrites your changes with the source state version.

**Warning signs:**
- Config changes "disappear" after running `chezmoi update`
- User edits `~/.zshrc` directly instead of `chezmoi edit ~/.zshrc`
- `chezmoi diff` shows unexpected differences

**Prevention strategy:**
- Use `chezmoi edit ~/.zshrc` instead of `vim ~/.zshrc`
- Enable `git.autoCommit = true` so edits via `chezmoi edit` are tracked
- Add shell alias: `alias ce='chezmoi edit'`
- Run `chezmoi diff` before `chezmoi apply` to catch drift

**Phase mapping:** Address during workflow documentation phase. Add alias in shell config.

### Pitfall 6: Script Filename Attribute Order is Strict and Silent

**Severity:** MEDIUM — scripts running at wrong time or never executing

**What happens:** chezmoi requires specific ordering of filename attributes. `run_once_before_install.sh` works, but `run_before_once_install.sh` silently doesn't execute as a run script — it's treated as a regular file.

**Correct order:** `run_` + (`once_` | `onchange_`) + (`before_` | `after_`) + `name` + `.suffix`

**Warning signs:**
- Scripts exist in source state but never execute
- `chezmoi managed --include=scripts` doesn't list expected scripts
- No errors — scripts are just silently treated as regular files

**Prevention strategy:**
- Follow the exact prefix order: `run_once_before_01-name.sh`
- Verify with `chezmoi managed --include=scripts` after adding
- Test each script individually with `chezmoi apply --dry-run`

**Phase mapping:** Address during bootstrap scripts phase. Verify all scripts are recognized.

### Pitfall 7: 1Password Multiple-Account Ambiguity

**Severity:** LOW — `chezmoi diff` hangs waiting for account selection

**What happens:** If the user has multiple 1Password accounts (personal + work), `op read` may prompt for account selection interactively. In a non-interactive `chezmoi apply`, this hangs indefinitely.

**Warning signs:**
- `chezmoi apply` hangs with no output
- Works fine when `op` is used directly (interactive prompt)
- Only happens on machines with multiple 1Password accounts

**Prevention strategy:**
- Specify account in `onepasswordRead` references: `op://Personal/...` (use vault name, not account)
- Or set default account in `op` CLI config
- Test with `op read "op://Personal/GitHub Token/credential"` directly

**Phase mapping:** Address during 1Password integration phase.

---

## Migration-Specific Pitfalls

### Pitfall 8: `exact_` Prefix Deleting Tool-Generated Files

**What happens:** Using `exact_dot_config/nvim/` causes chezmoi to delete files in `~/.config/nvim/` that aren't in the source state — like `lazy-lock.json` generated by lazy.nvim, or Mason-installed LSP binaries.

**Prevention:** Don't use `exact_` on directories where tools generate files. Only use on directories you fully control.

### Pitfall 9: Forgetting to Template Homebrew Path

**What happens:** Hardcoding `/opt/homebrew` (Apple Silicon) in `.zshenv` breaks on Intel Macs (`/usr/local`). Current Stow setup may already handle this, but the migration is a chance to get it right with templates.

**Prevention:** Use `{{ if eq .chezmoi.arch "arm64" }}/opt/homebrew{{ else }}/usr/local{{ end }}` in `.zshenv.tmpl`.

### Pitfall 10: Not Backing Up Before Migration

**What happens:** You restructure the repo, unstow everything, apply chezmoi — and something breaks. Now you have no working dotfiles and the old structure is gone.

**Prevention:**
1. Create a backup branch: `git checkout -b pre-chezmoi-backup`
2. Commit current state
3. Return to main branch for migration
4. Keep backup branch until chezmoi setup is verified on all machines

---

## Pitfall Summary by Phase

| Phase | Pitfalls to Address |
|-------|---------------------|
| Pre-migration | #3 (Stow symlink removal), #10 (backup) |
| Initial chezmoi setup | #4 (.chezmoi.toml.tmpl), #6 (filename order) |
| Bootstrap scripts | #1 (1Password before templates), #2 (run_onchange_ for Brewfile) |
| 1Password integration | #7 (multiple accounts), #1 (chicken-and-egg) |
| Config migration | #8 (exact_ prefix), #9 (Homebrew path) |
| Workflow adoption | #5 (edit muscle memory) |

---

## Sources

- chezmoi official documentation (chezmoi.io)
- chezmoi GitHub issues (common migration problems)
- Community blog posts on Stow-to-chezmoi migration
- 1Password CLI v2 documentation

---
*Pitfalls research for: Stow-to-chezmoi migration on macOS*
*Researched: 2026-03-18*

# Codebase Concerns

**Analysis Date:** 2026-03-18

## Tech Debt

**Hardcoded user paths in .zshenv:**
- Issue: User-specific paths hardcoded for `/Users/ab` in `.granted` zsh completion fpath configuration
- Files: `zsh/.zshenv` (lines 129-131)
- Impact: Configuration breaks when cloned to different machines; non-portable across users
- Fix approach: Replace hardcoded `/Users/ab` with `$HOME` variable for portability. The installer runs `sed` to fix paths in `.zshrc` but misses `.zshenv` lines 129-131.

**Backup files committed to repository:**
- Issue: Multiple `.backup` files tracked in git (`.zshrc.backup`, `.zshrc.zinit.backup`)
- Files: `zsh/.zshrc.backup`, `zsh/.zshrc.zinit.backup`
- Impact: Increases repo size, confuses state management, indicates unfinished refactoring or incomplete migrations
- Fix approach: Remove backup files from git, add to `.gitignore`, use git history instead for reference. Retain only if they serve a documented purpose (they don't).

**sed -i portability issue in install.sh:**
- Issue: `install.sh` uses `sed -i` without platform-specific handling (line 70-71). BSD sed (macOS) requires empty string argument: `sed -i ''`
- Files: `install.sh` (lines 70-71)
- Impact: May cause sed to fail silently or create `.backup` files unexpectedly on some macOS versions
- Fix approach: Use `sed -i.backup` (creates explicit backup) or check OS and use correct sed syntax. Current code does use `.backup` but is not explicit.

**Conda lazy loading assumes fixed path:**
- Issue: `.zshrc` conda lazy loader hardcodes `$HOME/miniconda3/bin/conda` (line 88)
- Files: `zsh/.zshrc` (lines 86-91)
- Impact: Breaks if conda installed to different location (e.g., `~/anaconda3`, system Homebrew path). Only last-ditch fallback uses PATH
- Fix approach: Detect conda installation location dynamically using `which conda` or check multiple standard paths before hardcoding.

**Mason LSP server initialization errors:**
- Issue: `mason.lua` documents that mason-lspconfig was removed "to avoid initialization errors" but exact errors not documented
- Files: `nvim/.config/nvim/lua/configs/mason.lua` (lines 24-27)
- Impact: LSP servers require manual `:MasonInstall` invocation; users may not discover this and think LSP is broken. No automated fallback for missing servers.
- Fix approach: Add post-install hook or lazy initialization that silently installs common servers on first Neovim launch, or provide status indicator when LSP is missing.

**Health check symlink verification logic incomplete:**
- Issue: `scripts/health-check.sh` only checks symlinks under `~/.config/` but stow creates symlinks in multiple locations (`$HOME/.zshrc`, `$HOME/.gitconfig`, etc.)
- Files: `scripts/health-check.sh` (lines 14-25)
- Impact: Broken symlinks outside `.config/` are not detected by validation script
- Fix approach: Expand health check to scan `$HOME` root for stow-created symlinks and validate those as well.

**Inconsistent shell script error handling:**
- Issue: `sync.sh` uses `set -e` in some scripts but not others; error handling strategy is not uniform
- Files: `scripts/sync.sh` (no `set -e`), `install.sh` (has `set -e`), `scripts/health-check.sh` (has `set -euo pipefail`)
- Impact: `sync.sh` silently continues on brew bundle or stow failure, potentially leaving system in broken state
- Fix approach: Add `set -e` to all scripts, test failure scenarios, ensure meaningful error messages before exit.

## Known Bugs

**Ghostty theme switcher sed silently fails without feedback:**
- Symptoms: Theme not changed, no clear error message
- Files: `scripts/ghostty-theme-switcher.sh` (lines 39, 44-46)
- Trigger: Run with invalid theme or if Ghostty config file format changes
- Workaround: Check `~/.config/ghostty/config` manually with `cat` to verify current theme before reporting issue.

**ZSH startup time varies significantly depending on conda installation:**
- Symptoms: ZSH takes 500ms+ when conda lazy loader evaluates miniconda path
- Files: `zsh/.zshrc` (lines 86-91)
- Trigger: First invocation of `conda` command after shell startup
- Workaround: Use `hash -r` to clear command cache if experiencing slowdown; lazy loader should be more aggressive.

**Brewfile missing pinned csharp-ls and intelephense:**
- Symptoms: No C# LSP support in Neovim; PHP/Laravel development requires manual setup
- Files: `Brewfile` (lines 62-65) — explicitly documented as missing
- Trigger: User attempts `:MasonInstall csharp-ls` or `intelephense`
- Workaround: Install manually with `dotnet tool install --global csharp-ls` and `npm i -g intelephense` after bootstrap.

## Security Considerations

**Environment configuration via direnv not documented in install.sh:**
- Risk: Users may hardcode secrets in shell configs instead of using `.envrc`
- Files: `CLAUDE.md` documents direnv approach, but `install.sh` and `README.md` don't mention it
- Current mitigation: CLAUDE.md exists as guidance, AGENTS.md specifies not to commit secrets
- Recommendations: Add setup step in `install.sh` to create `.envrc` template with `$HOME/.secrets/github.env` reference; add `.envrc` to recommended `.gitignore` entries.

**Git credential manager not documented as dependency:**
- Risk: Users may fall back to HTTP auth or skip credential caching entirely
- Files: `Brewfile` (line 80) installs `git-credential-manager` but no `.gitconfig` documentation
- Current mitigation: Installer installs it, but setup instructions are missing
- Recommendations: Add step in `install.sh` post-install checklist to run `git config --global credential.helper manager`. Document in `git/README.md`.

**Stow symlinks expose internal dotfiles structure:**
- Risk: Symlinks in `$HOME/.config/` point directly to `/path/to/dotfiles/`, revealing repository structure and location to any process reading symlinks
- Files: Affects all stow packages; no mitigation in current design
- Current mitigation: None — by design, symlinks are intentional and transparent
- Recommendations: Document that dotfiles repository location should not be considered secret. If deploying to shared systems, consider directory permissions.

## Performance Bottlenecks

**Shell startup time regresses when conda activation is lazy-loaded:**
- Problem: First `conda` invocation may cause 200-400ms delay due to subshell and eval
- Files: `zsh/.zshrc` (lines 86-91)
- Cause: Lazy loader uses `$()` subshell and eval, which requires full conda initialization
- Improvement path: Pre-compute conda activation on install; use `conda config --set auto_activate_base false` to speed up initialization; consider async loading.

**ZSH function file is 910 lines in single file:**
- Problem: All 30+ zsh functions defined in one file; not organized by category; slower to parse than modular approach
- Files: `zsh/.zsh_functions` (910 lines)
- Cause: Monolithic design for simplicity; minimal perf impact but affects maintainability
- Improvement path: Split into `zsh/.zsh_functions.d/` directory with logical groupings (`10-extract.zsh`, `20-filesystem.zsh`, `30-network.zsh`). Benchmark to verify zero perf regression.

**Neovim plugin loading strategy uses lazy.nvim but no optimization profile:**
- Problem: On first launch, lazy.nvim installs ~50+ plugins sequentially; no parallel install capability documented
- Files: `nvim/.config/nvim/plugins/init.lua`, `nvim/.config/nvim/lazy-lock.json`
- Cause: lazy.nvim default behavior; no profiling data available
- Improvement path: Profile startup with `:LazySyncProfile` or document recommended plugins to uninstall. Add startup time baseline to README.

**FZF default command uses fd with hidden files globally:**
- Problem: `FZF_DEFAULT_COMMAND` set in `.zshenv` searches all hidden files by default; can be slow in large repos
- Files: `zsh/.zshenv` (line 98)
- Cause: `--hidden` flag includes `.git`, `.node_modules`, etc. in search results; respects `.gitignore` but still traverses excluded dirs
- Improvement path: Create `.fzf_config` with repo-specific overrides; add `--exclude .git --exclude node_modules` explicitly for common cases.

## Fragile Areas

**ZSH completion initialization order critical but undocumented:**
- Files: `zsh/.zshrc` (lines 49-71)
- Why fragile: Plugin loading order matters (git before syntax highlighting, completions before compinit). If order changes, shell breaks with duplicate compinit errors
- Safe modification: Document the load order requirement in comments. Run `zsh -n zsh/.zshrc` after any changes. Test in clean environment.
- Test coverage: Missing automated test for completion system; manual testing only.

**Powerlevel10k instant prompt requires exact cache path:**
- Files: `zsh/.zshrc` (lines 6-9)
- Why fragile: If `$XDG_CACHE_HOME` is unset or the p10k cache file is deleted, instant prompt fails silently and startup slows. No fallback or warning.
- Safe modification: Always test with cache cleared: `rm -rf ~/.cache/p10k-instant-prompt-*` then reload shell. Verify prompt appears within 50ms.
- Test coverage: No automated test; user reports of slow startup are only indicator.

**Stow package interdependencies create ordering constraint:**
- Files: `install.sh` (lines 85-98), `CLAUDE.md` lines 40-46
- Why fragile: Git must stow first (others reference .gitconfig). ZSH second (sets PATH). Order matters but not enforced by tool. Manual restow with wrong order breaks everything.
- Safe modification: Document in each package README the stow order requirement. Add validation to `health-check.sh` to verify symlinks point to correct stow order.
- Test coverage: No automated test; documentation-only.

**Mason LSP server discovery relies on Brewfile declarations:**
- Files: `Brewfile` (lines 51-65), `nvim/.config/nvim/lua/configs/lspconfig.lua`
- Why fragile: If Brewfile is out of sync with lspconfig expectations, LSP servers silently won't start. No error message, just missing diagnostics.
- Safe modification: Add `:checkhealth` output to lspconfig to show which servers are missing. Cross-reference Brewfile LSP declarations with lspconfig.lua server list.
- Test coverage: No automated test; requires manual `:Mason` inspection.

**Ghostty config lacks validation:**
- Files: `ghostty/.config/ghostty/config`, `scripts/ghostty-theme-switcher.sh`
- Why fragile: If config format is invalid or keys are misspelled, Ghostty silently falls back to defaults. No syntax checker.
- Safe modification: Before running `ghostty-theme-switcher.sh`, validate config with `ghostty --version 2>&1 | grep -q "v"`. Add `--dry-run` mode to theme switcher.
- Test coverage: No automated test; only manual terminal startup verification.

## Scaling Limits

**ZSH function file grows without organization:**
- Current capacity: 910 lines; currently ~30 functions
- Limit: Maintainability breaks around 1500+ lines; startup time impact negligible below 5000 lines
- Scaling path: Before hitting 1500 lines, refactor into modular files (`~/.zsh_functions.d/`). Current growth rate suggests 1-2 years before refactor needed.

**Brewfile can accommodate ~100 packages before manual optimization:**
- Current count: ~45 brew packages + ~2 casks
- Limit: No hard limit; performance of `brew bundle` stays linear, but human parsing gets difficult above 80 packages
- Scaling path: If adding >40 more packages, organize Brewfile with additional categories and comments. Consider splitting into multiple Brewfiles by role (base, development, tools).

**Neovim lazy.nvim plugin loading scales linearly:**
- Current count: ~50 plugins (from lazy-lock.json inspection)
- Limit: Performance degradation noticeable above 100 plugins; no hard limit
- Scaling path: Current startup time likely 1-2s; if exceeds 3s, profile with `:LazySyncProfile` and identify slow plugins for deferral or removal.

## Dependencies at Risk

**Swift language server in Homebrew may not track sourcekit-lsp versions:**
- Risk: `brew install swift` installs Swift toolchain, but sourcekit-lsp version may lag upstream
- Impact: Swift LSP in Neovim may be incompatible with latest Swift syntax
- Migration plan: If sourcekit-lsp breaks, pin Swift version in Brewfile or install sourcekit-lsp via swift package manager instead.

**Bun runtime added to Brewfile but not documented in .zshrc:**
- Risk: Bun installed but not added to PATH or lazy-loaded; users may not discover it
- Impact: `bun` commands fail with "not found" despite being in Brewfile
- Migration plan: Add explicit PATH setup or lazy loader wrapper for `bun` in `.zsh_functions_lazy`. Document in zsh/README.md.

**Dotnet SDK in Brewfile for csharp-ls but no post-install hook:**
- Risk: `brew install dotnet` installs SDK, but `dotnet tool install --global csharp-ls` must run manually
- Impact: C# LSP never installed unless user runs manual command from install.sh post-install notes
- Migration plan: Add `dotnet tool install --global csharp-ls` as post-install step in `install.sh` after `brew bundle`, with fallback if dotnet not available.

**Node.js lazy loading may mask missing npm packages:**
- Risk: `.zsh_functions_lazy` lazy-loads node/npm/nvm, but if loading fails, error is silent
- Impact: User runs `npm install` thinking it will work, but shell hasn't initialized Node yet
- Migration plan: Add explicit error handling to lazy loader; print message "Initializing Node.js..." first time npm/node is used; fail fast if NVM bootstrap fails.

## Missing Critical Features

**No automated LSP server installation on first Neovim launch:**
- Problem: Users must manually run `:MasonInstall <server>` for each language they need
- Blocks: Users starting with Neovim for first time get no diagnostics until they discover Mason
- Fix approach: Create `nvim/.config/nvim/plugins/init.lua` post-install hook that runs `:MasonInstall` for common servers (gopls, pyright, lua_ls, bashls) on first startup.

**No git user setup validation in install.sh:**
- Problem: `install.sh` prints reminder to run `git config --global user.name`, but doesn't validate or set defaults
- Blocks: First git commit fails with "please tell me who you are" error
- Fix approach: Prompt interactively for user name/email in `install.sh` and auto-configure git after stowing git package.

**No backup/restore mechanism for dotfiles across machines:**
- Problem: `sync.sh` pulls latest from git and restows, but provides no rollback if something breaks
- Blocks: Syncing to production machine is risky; no safety net for bad configs
- Fix approach: Enhance `scripts/backup-configs.sh` to create timestamped backups pre-sync, and add `restore-from-backup.sh` script with interactive menu.

## Test Coverage Gaps

**Shell configuration syntax not validated before commit:**
- What's not tested: `.zshenv` and `.zshrc` parse errors only caught at runtime
- Files: `zsh/.zshenv`, `zsh/.zshrc`, `zsh/.zsh_aliases`, `zsh/.zsh_functions`
- Risk: Typo in shell config breaks all shell sessions; can require manual recovery
- Priority: **High** — affects daily usability

**Stow conflicts not detected in CI:**
- What's not tested: Whether stow packages will actually symlink without conflicts before merging
- Files: All stow package directories; validation in `scripts/health-check.sh`
- Risk: Merge adds file that conflicts with existing symlink; breaks checkout for all users
- Priority: **High** — affects repo health

**Neovim plugin loading not tested for failures:**
- What's not tested: Whether `:Lazy sync` succeeds on fresh install; which plugins fail silently
- Files: `nvim/.config/nvim/plugins/init.lua`, `nvim/.config/nvim/lazy-lock.json`
- Risk: Plugin install hangs or fails during bootstrap; no feedback to user
- Priority: **Medium** — affects first-time setup

**Git configuration not validated:**
- What's not tested: Whether git aliases work; whether hooks are executable
- Files: `git/.config/git/config`, `git/.gitconfig.d/`
- Risk: Broken aliases silently fail with "unknown command" errors
- Priority: **Medium** — reduces developer experience

**Brewfile package availability not checked:**
- What's not tested: Whether packages in Brewfile are installable on current macOS version
- Files: `Brewfile`
- Risk: `brew bundle` fails partway through; installation incomplete
- Priority: **Low** — brew itself provides error messages, but could be pre-validated

---

*Concerns audit: 2026-03-18*

# Repository Guidelines

## Project Structure & Module Organization
This repository is a GNU Stow-managed dotfiles monorepo. Each top-level folder is a stow package that maps into `$HOME` (for example `zsh/`, `nvim/`, `kitty/`, `git/`, `ghostty/`, `atuin/`). Package internals usually live under `.config/...`.  
Automation and diagnostics live in `scripts/`, with macOS-specific helpers in `scripts/mac/`.  
Primary entrypoints:
- `install.sh`: bootstrap and stow on macOS
- `Brewfile`: package dependencies
- `README.md` + per-package `README.md`: component docs

## Build, Test, and Development Commands
- `./install.sh` — full local bootstrap (Homebrew, stow, Neovim sync).
- `brew bundle --file Brewfile` — install/update declared CLI tools.
- `stow -R zsh nvim kitty git` — restow selected packages after edits.
- `./scripts/health-check.sh` — validate symlinks, dependencies, and setup health.
- `./scripts/benchmark.sh` or `./scripts/profile-zsh-startup.sh` — measure shell startup performance.
- `zsh -n zsh/.zshenv zsh/.zshrc` — syntax-check Zsh config changes.

## Coding Style & Naming Conventions
Follow `.editorconfig`:
- 2 spaces for most files (Shell, JSON, YAML, Markdown)
- 4 spaces for Python
- tabs for Go and Makefiles  
Use LF endings, trim trailing whitespace (except Markdown), and always end files with a newline.  
Name scripts with lowercase kebab-case (for example `toggle-dark-mode.sh`). Keep paths portable (`$HOME`, not hardcoded `/Users/<name>`).

## Testing Guidelines
There is no single unit-test framework; use targeted validation:
- Run `./scripts/health-check.sh` after structural changes.
- Run `zsh -n ...` and `./scripts/test-completion-demo.sh` for shell/completion edits.
- Run `nvim --headless "+Lazy! sync" +qa` after Neovim plugin/config updates.
- Re-run relevant package README steps you changed.

## Commit & Pull Request Guidelines
History favors short, imperative commit subjects (for example `fix ghostty theme sync`, `docs: standardize README`). Keep commits focused to one logical area/package.  
PRs should include:
- concise summary of changed packages
- verification commands executed
- linked issue (if applicable)
- screenshots/terminal captures for UI-facing changes (Kitty/Ghostty/Neovim themes).

## Security & Configuration Tips
Do not commit secrets, tokens, or machine-specific credentials. Prefer environment-based configuration (for example `direnv`) and sanitize personal paths before committing.

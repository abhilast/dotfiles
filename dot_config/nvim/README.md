# Neovim Configuration

## Overview

Streamlined Neovim setup based on NvChad v2.5, optimized for DevOps workflows and large monorepo navigation. Provides dual search engines (Telescope and FZF-Lua), comprehensive LSP support with auto-schema validation, and language-specific tooling for Go, Python, Terraform, Kubernetes, Helm, and Docker.

## Features

- Fast navigation with both FZF-Lua and Telescope (use whichever fits)
- LSP support for 12+ languages with automatic schema validation (JSON via SchemaStore, YAML via yamlls with Kubernetes/Istio schemas)
- Multi-file management with splits, tabs, buffers, and Harpoon bookmarks
- DevOps-first file type detection (Terraform, Docker, Helm, Kubernetes, Ansible, GitLab CI)
- Git integration with Diffview, gitsigns (inline blame), and FZF-Lua git pickers
- Debugging with nvim-dap for Go and Python
- Testing with neotest for Go and Python (pytest)
- Markdown preview with Glow and render-markdown
- Format-on-save via conform.nvim
- Flash.nvim for rapid in-buffer motion
- Code folding via nvim-ufo (treesitter-based)
- DevOps snippet library (Kubernetes, Terraform, Docker Compose, Helm, Python, Go)

## Configuration Location

Managed by chezmoi. Source files live under `dot_config/nvim/` in the dotfiles repo and are deployed to `~/.config/nvim/`.

## Dependencies

Required tools (install via Homebrew):

```bash
brew install fd ripgrep glow node python fzf bat eza
```

## Configuration Files

| File | Purpose |
|------|---------|
| `init.lua` | Entry point: bootstraps lazy.nvim, loads NvChad v2.5, theme, options, and mappings |
| `lua/chadrc.lua` | NvChad configuration: base46 theme (`default-light`), NVDash on startup, tabufline |
| `lua/mappings.lua` | All custom keybindings |
| `lua/options.lua` | Vim options, performance tuning, autocommands |
| `lua/plugins/init.lua` | Plugin specifications (lazy.nvim) |
| `lua/configs/lspconfig.lua` | LSP server setup for all languages |
| `lua/configs/conform.lua` | Formatter configuration (format-on-save) |
| `lua/configs/telescope.lua` | Telescope setup optimized for large repos |
| `lua/configs/fzf-lua.lua` | FZF-Lua setup as a fast alternative finder |
| `lua/configs/neo-tree.lua` | File explorer with git status and monorepo filtering |
| `lua/configs/harpoon.lua` | Harpoon v2 quick-file navigation |
| `lua/configs/mason.lua` | Mason package manager UI and settings |
| `lua/configs/yamlls.lua` | YAML Language Server with Kubernetes and Istio schemas |
| `lua/configs/kubernetes.lua` | Auto-detection of Kubernetes YAML files |
| `lua/configs/filetype.lua` | DevOps file type detection rules |
| `lua/configs/snippets.lua` | LuaSnip DevOps snippets |
| `lua/configs/ufo.lua` | Code folding configuration |
| `lua/configs/lazy.lua` | Lazy.nvim performance settings and disabled built-in plugins |

## Core Shortcuts

### Essential Navigation

| Shortcut | Action |
|----------|--------|
| `<C-p>` | Quick file finder (FZF-Lua) |
| `<C-f>` | Live grep search (FZF-Lua) |
| `<leader><leader>` | Quick buffer switch |
| `<leader>e` | Toggle file tree (Neo-tree) |

### Basic Operations

| Shortcut | Action |
|----------|--------|
| `;` | Command mode |
| `jk` | Escape (insert mode) |
| `s` | Flash jump |
| `S` | Flash treesitter |

## File Navigation and Search

### Smart Project Navigation

| Shortcut | Action |
|----------|--------|
| `<leader>pf` | Project files (smart, from git root) |
| `<leader>pg` | Git tracked files |
| `<leader>pr` | Recent project files (cwd only) |

### Telescope Search

| Shortcut | Action |
|----------|--------|
| `<leader>ff` | Smart find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Find buffers |
| `<leader>fh` | Help tags |
| `<leader>fo` | Old files |
| `<leader>fc` | Commands |
| `<leader>fk` | Keymaps |
| `<leader>fG` | Live grep with args (supports ripgrep flags) |
| `<leader>ft` | Find TODOs |

### FZF-Lua (Fast Alternative)

| Shortcut | Action |
|----------|--------|
| `<leader>Ff` | FZF files |
| `<leader>Fg` | FZF live grep |
| `<leader>Fb` | FZF buffers |
| `<leader>Fo` | FZF old files |
| `<leader>Fh` | FZF help |
| `<leader>Fc` | FZF commands |
| `<leader>Fk` | FZF keymaps |

### File Type Searches

| Shortcut | Action |
|----------|--------|
| `<leader>fey` | Find YAML files |
| `<leader>fej` | Find JSON files |
| `<leader>fep` | Find Python files |
| `<leader>feg` | Find Go files |
| `<leader>fes` | Find shell scripts |

### Advanced Search

| Shortcut | Action |
|----------|--------|
| `<leader>ds` | Grep in directory (prompts for path) |
| `<leader>dg` | Grep in git root |
| `<leader>*` | Grep word under cursor |
| `<leader>#` | Grep WORD under cursor |

## Window, Buffer, and Tab Management

### Window Splitting

| Shortcut | Action |
|----------|--------|
| `<leader>sv` | Vertical split |
| `<leader>sh` | Horizontal split |
| `<leader>sfv` | Find file in vertical split |
| `<leader>sfh` | Find file in horizontal split |
| `<leader>sft` | Find file in new tab |

### Window Management

| Shortcut | Action |
|----------|--------|
| `<leader>se` | Equalize windows |
| `<leader>sc` | Close window |
| `<leader>so` | Close all other windows |

### Preset Layouts

| Shortcut | Action |
|----------|--------|
| `<leader>w2` | 2-column layout |
| `<leader>w3` | 3-column layout |
| `<leader>w4` | 4-window grid |
| `<leader>wt` | Horizontal terminal split (10 rows) |
| `<leader>wT` | Vertical terminal split (80 columns) |

### Window Navigation

| Shortcut | Action |
|----------|--------|
| `<C-h>` | Move left |
| `<C-j>` | Move down |
| `<C-k>` | Move up |
| `<C-l>` | Move right |

### Window Resizing

| Shortcut | Action |
|----------|--------|
| `<C-Up>` | Increase height |
| `<C-Down>` | Decrease height |
| `<C-Left>` | Decrease width |
| `<C-Right>` | Increase width |

### Buffer Operations

| Shortcut | Action |
|----------|--------|
| `<leader>x` | Delete buffer |
| `<leader>X` | Force delete buffer |
| `]b` / `<S-l>` | Next buffer |
| `[b` / `<S-h>` | Previous buffer |
| `<leader>bl` | List buffers |

### Tab Management

| Shortcut | Action |
|----------|--------|
| `<leader>tn` | New tab |
| `<leader>tc` | Close tab |
| `<leader>to` | Close other tabs |
| `<leader>tp` | Previous tab |
| `<leader>tN` | Next tab |
| `<leader>tm` | Move tab |
| `<leader>1-5` | Go to tab 1-5 |

### Harpoon (Quick File Bookmarks)

| Shortcut | Action |
|----------|--------|
| `<leader>ha` | Add file to Harpoon |
| `<leader>hh` | Toggle Harpoon menu |
| `<leader>h1-4` | Jump to Harpoon file 1-4 |
| `<leader>hp` | Previous Harpoon file |
| `<leader>hn` | Next Harpoon file |

Harpoon marks are branch-aware and scoped to the current working directory.

## Directory Navigation

### Quick Directory Access

| Shortcut | Action |
|----------|--------|
| `<leader>dd` | Navigate to directory (fzf + Neo-tree) |
| `<leader>dcd` | Change directory (pure fcd-style) |
| `<leader>dc` | Files in current dir |
| `<leader>dp` | Files in parent dir |
| `<leader>dh` | Files in home dir |
| `<leader>dr` | Files in git root |
| `-` | Browse parent directory |
| `_` | Browse current directory |

### Quick Directory Jumps

| Shortcut | Action |
|----------|--------|
| `<leader>d.` | Config directory |
| `<leader>dt` | Temp directory |
| `<leader>dl` | Log directory |

### Directory Bookmarks

| Shortcut | Action |
|----------|--------|
| `<leader>bc` | `~/.config` directory |
| `<leader>bn` | `~/.config/nvim` directory |

### Change Working Directory

| Shortcut | Action |
|----------|--------|
| `<leader>cd` | Change to file directory |
| `<leader>cD` | Change to parent |
| `<leader>ch` | Change to home |
| `<leader>cw` | Show working directory |

## LSP and Code Features

### LSP Navigation

| Shortcut | Action |
|----------|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | Show references |
| `K` | Hover documentation |
| `<C-k>` | Signature help |

### LSP Actions

| Shortcut | Action |
|----------|--------|
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code actions |
| `<leader>f` | Format document |

### LSP Telescope Integration

| Shortcut | Action |
|----------|--------|
| `<leader>fs` | Document symbols |
| `<leader>fS` | Workspace symbols |
| `<leader>fr` | LSP references |
| `<leader>fi` | LSP implementations |
| `<leader>fd` | LSP definitions |
| `<leader>fD` | Diagnostics |

### LSP FZF-Lua Integration

| Shortcut | Action |
|----------|--------|
| `<leader>Fs` | FZF document symbols |
| `<leader>FS` | FZF workspace symbols |
| `<leader>Fr` | FZF references |
| `<leader>Fi` | FZF implementations |
| `<leader>Fd` | FZF definitions |
| `<leader>FD` | FZF diagnostics |

### File Outline

| Shortcut | Action |
|----------|--------|
| `<leader>o` | File outline (FZF-Lua symbols) |
| `<leader>O` | File outline (Telescope, detailed) |
| `<leader>wo` | Workspace symbols |

## Diagnostics and Navigation

### Diagnostic Navigation

| Shortcut | Action |
|----------|--------|
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |
| `<leader>D` | Show diagnostic float |

### Trouble.nvim

| Shortcut | Action |
|----------|--------|
| `<leader>xx` | Toggle diagnostics (Trouble) |
| `<leader>xX` | Buffer diagnostics (Trouble) |
| `<leader>cs` | Symbols (Trouble) |
| `<leader>cl` | LSP definitions/references (Trouble) |
| `<leader>xL` | Location list (Trouble) |
| `<leader>xQ` | Quickfix list (Trouble) |

### Search Navigation (Centered)

| Shortcut | Action |
|----------|--------|
| `n` | Next search result (centered) |
| `N` | Previous search result (centered) |
| `*` | Search word forward (centered) |
| `#` | Search word backward (centered) |

### Jump Navigation (Centered)

| Shortcut | Action |
|----------|--------|
| `<C-o>` | Jump back (centered) |
| `<C-i>` | Jump forward (centered) |

### Reference Navigation (Quickfix)

| Shortcut | Action |
|----------|--------|
| `]r` | Next reference |
| `[r` | Previous reference |
| `]R` | Last reference |
| `[R` | First reference |

### Quickfix List Management

| Shortcut | Action |
|----------|--------|
| `<leader>qo` | Open quickfix |
| `<leader>qc` | Close quickfix |
| `<leader>qq` | Close quickfix (quick) |
| `<C-q>` | Close quickfix (super quick) |

## File Explorer (Neo-tree)

| Shortcut | Action |
|----------|--------|
| `<leader>e` | Toggle Neo-tree |
| `<leader>E` | Focus Neo-tree |
| `<leader>ef` | Reveal current file |
| `<leader>ec` | Close Neo-tree |
| `<leader>er` | Neo-tree as file manager |
| `<leader>ge` | Neo-tree git status |
| `<leader>be` | Neo-tree buffers |

Neo-tree is configured to hide common build artifacts (.git, node_modules, .terraform, target, build, dist, __pycache__) while always showing DevOps files (.gitignore, .env, Dockerfile, docker-compose.yml, .github, .gitlab-ci.yml).

## Git Integration

### Git Pickers (FZF-Lua)

| Shortcut | Action |
|----------|--------|
| `<leader>gf` | Git files |
| `<leader>gs` | Git status |
| `<leader>gl` | Git log |
| `<leader>gL` | Git buffer commits |
| `<leader>gb` | Git branches |

### Diffview

| Shortcut | Action |
|----------|--------|
| `<leader>gd` | Open diff view |
| `<leader>gh` | Git file history |
| `<leader>gc` | Close diff view |

### Gitsigns

Inline git blame is enabled by default (1s delay, shown at end of line).

## Debugging (nvim-dap)

| Shortcut | Action |
|----------|--------|
| `<Space>b` | Toggle breakpoint |
| `<Space>gb` | Run to cursor |
| `<F1>` | Continue |
| `<F2>` | Step into |
| `<F3>` | Step over |
| `<F4>` | Step out |
| `<F5>` | Step back |
| `<F13>` | Restart |

DAP-UI opens automatically on debug start and closes on termination. Go and Python debuggers are configured (Python uses pipenv venv detection with Mason debugpy fallback).

## Testing (neotest)

Neotest is configured with adapters for:
- **Python:** pytest runner with pipenv-aware python path
- **Go:** Table-driven test support, 60s timeout

## Terminal (ToggleTerm)

| Shortcut | Action |
|----------|--------|
| `<C-\>` | Toggle terminal (float by default) |
| `<leader>tf` | Toggle floating terminal |
| `<leader>th` | Toggle horizontal terminal |
| `<leader>tv` | Toggle vertical terminal (80 columns) |

## Language Support

### Go Development

| Shortcut | Action |
|----------|--------|
| `<leader>gr` | Go run |
| `<leader>gt` | Go test |
| `<leader>gb` | Go build |
| `<leader>gi` | Go install deps |
| `<leader>gf` | Go format |

Note: `<leader>gb` and `<leader>gf` are also mapped to Git pickers (FZF-Lua). The Go mappings take effect when in Go files, but in practice use `:GoBuild` and `:GoFmt` commands or the command palette to avoid conflicts.

### Python Development

| Shortcut | Action |
|----------|--------|
| `<leader>pr` | Run Python file |
| `<leader>pt` | Run pytest |

Pyright is configured with automatic pipenv venv detection and basic type checking.

### YAML Support

| Shortcut | Action |
|----------|--------|
| `<leader>yv` | YAML lint (via Mason yamllint) |

YAML Language Server provides schema validation for Kubernetes, Istio, Docker Compose, and GitLab CI files. Use the `:K8sSchema` command to manually apply Kubernetes schema to a buffer.

### Terraform

- Auto-formatting on save via `terraform_fmt`
- LSP support via `terraformls`
- Telescope Terraform extension for resource browsing
- Snippets for resources, variables, outputs, and AWS provider

## Code Folding (nvim-ufo)

| Shortcut | Action |
|----------|--------|
| `zR` | Open all folds |
| `zM` | Close all folds |
| `zr` | Open folds except kinds |
| `zm` | Close folds incrementally |

Folding uses treesitter as the primary provider with indent as fallback.

## TODO Comments

| Shortcut | Action |
|----------|--------|
| `<leader>td` | Todo Telescope |
| `<leader>tq` | Todo QuickFix |
| `<leader>tl` | Todo LocList |
| `]t` | Next todo |
| `[t` | Previous todo |

Recognized keywords: TODO, FIX/FIXME/BUG, HACK, WARN/WARNING/XXX, PERF/OPTIM, NOTE/INFO, TEST.

## File Comparison

| Shortcut | Action |
|----------|--------|
| `<leader>vd` | Vertical diff split (prompts for file) |
| `<leader>vD` | Horizontal diff split (prompts for file) |
| `<leader>vf` | Turn off diff mode |

## File Path Utilities

| Shortcut | Action |
|----------|--------|
| `<leader>cp` | Copy full path |
| `<leader>cf` | Copy filename |
| `<leader>cr` | Copy relative path |

## Markdown Preview

| Shortcut | Action |
|----------|--------|
| `<leader>mp` | Glow preview |
| `<leader>mg` | Toggle glow |
| `<leader>mr` | Toggle render-markdown |
| `<leader>mt` | Glow in terminal buffer |

## LSP and Mason Management

| Shortcut | Action |
|----------|--------|
| `<leader>lm` | Open Mason |
| `<leader>li` | LSP Info |
| `<leader>lr` | LSP Restart |
| `<leader>ll` | Mason Log |
| `<leader>lu` | Mason Update |

### Installed LSP Servers

Install via Mason (`:MasonInstall <server>`):

| Server | Language |
|--------|----------|
| `lua_ls` | Lua |
| `pyright` | Python |
| `gopls` | Go |
| `terraformls` | Terraform / HCL |
| `yamlls` | YAML |
| `bashls` | Bash |
| `dockerls` | Docker |
| `docker_compose_language_service` | Docker Compose |
| `helm_ls` | Helm |
| `jsonls` | JSON (with SchemaStore) |
| `sqls` | SQL |
| `html` | HTML |
| `cssls` | CSS |

### Format-on-Save

Formatters are configured per language in `configs/conform.lua`:

| Language | Formatters |
|----------|-----------|
| Python | black, isort |
| Go | goimports, gofmt |
| Terraform | terraform_fmt |
| YAML/JSON/Markdown/HTML/CSS | prettier |
| Shell | shfmt |
| Lua | stylua |

## Dashboard

| Shortcut | Action |
|----------|--------|
| `<leader>d` | Open NvChad dashboard |

The dashboard loads on startup (`nvdash.load_on_startup = true`).

## Editor Options

Key options set in `lua/options.lua`:

- **Relative line numbers** enabled
- **Smart case** search (case-insensitive unless uppercase is used)
- **Persistent undo** (`undofile` enabled, stored in `stdpath("data")/undodir`)
- **No swap/backup files**
- **Scroll offset:** 8 lines vertical, 8 columns horizontal
- **Default indent:** 2 spaces (Go uses tabs, Python uses 4 spaces)
- **Auto-save** on focus lost or buffer switch
- **Highlight yanked text** (200ms flash)
- **Trim trailing whitespace** on save
- **Large file handling:** Files over 1MB automatically disable syntax, treesitter, spell, and sign column
- **Grep program:** ripgrep with `--vimgrep --smart-case --hidden`

## Snippets

DevOps snippets are available via LuaSnip for:

- **YAML:** `k8s-deploy`, `k8s-svc`, `docker-compose`, `helm-values`
- **Terraform:** `tf-resource`, `tf-var`, `tf-output`, `tf-aws-provider`
- **Python:** `main`, `docstring`, `pytest`
- **Go:** `iferr`, `struct`, `test`

VSCode-compatible snippets are also loaded via friendly-snippets.

## Tips

- Use `<C-p>` and `<C-f>` for the fastest file/grep navigation (FZF-Lua)
- Master buffer switching with `<S-l>` and `<S-h>` or `<leader><leader>`
- Use `<leader>w3` for a 3-column comparison layout
- Centered navigation (`n`, `N`, `*`, `#`) keeps search context visible
- LSP features activate automatically when language servers are installed via Mason
- Harpoon bookmarks persist per branch and per directory -- great for jumping between related files in a project
- Flash.nvim (`s` to jump) replaces the need for EasyMotion or similar plugins

# Lazygit

[Lazygit](https://github.com/jesseduffield/lazygit) is a terminal UI for Git. It provides a visual, interactive interface for staging changes, committing, branching, rebasing, and navigating Git history -- all without leaving the terminal.

## Configuration

The config file is `config.yml`, managed directly by chezmoi (no templating needed).

### Diff Pipeline: Difftastic + Delta

The main customization in this config is the Git pager setup, which chains two diff tools together:

```yaml
git:
  pagers:
    - command: difft --color=always
      pager: delta --paging=never
      useConfig: false
```

This creates a pipeline where:

1. **[Difftastic](https://github.com/Wilfred/difftastic)** (`difft`) runs first as the diff command. Difftastic is a structural diff tool that understands programming language syntax, producing more meaningful diffs than line-based tools.
2. **[Delta](https://github.com/dandavits/delta)** receives difftastic's output and handles presentation (styling, line numbers, side-by-side view, etc.). The `--paging=never` flag is set because lazygit handles its own scrolling.
3. **`useConfig: false`** tells lazygit not to inherit settings from the user's global Git config for this pager, keeping the lazygit diff pipeline self-contained.

This mirrors the difftastic + delta setup in the global Git config (`dot_gitconfig.tmpl`) but is configured independently for lazygit's UI.

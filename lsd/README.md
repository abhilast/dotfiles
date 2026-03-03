# LSD Configuration

## Overview
LSD is configured via:
- `lsd/.config/lsd/config.yaml`

## Install
```bash
cd ~/dotfiles
stow lsd
```

## Alias Behavior In This Repo
Your shell keeps native `ls` and adds separate LSD aliases:
- `lls='lsd'`
- `lll='lsd -l'`
- `lla='lsd -la'`
- `llt='lsd --tree'`

Defined in `zsh/.zsh_aliases`.

## Common Usage
```bash
lsd
lsd -l
lsd -la
lsd --tree
lsd --tree -d 2
```

## Config Highlights
Current `config.yaml` includes:
- `classic: false`
- `icons.when: auto`
- `icons.theme: fancy`
- `date: date`
- `sorting.column: name`
- `sorting.dir-grouping: none`
- ignore globs for `.git`, `node_modules`, `.DS_Store`

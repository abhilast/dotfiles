# Go Configuration

## Overview
This package currently tracks Revive lint rules only:
- `go/revive/.revive.toml`

## Install
```bash
cd ~/dotfiles
stow go
```

## Tooling Notes
- This repo's `Brewfile` does **not** currently declare `brew "go"`.
- `zsh/.zsh_aliases` wraps `go test` through `richgo` when available.
- `zsh/.zshenv` sets `GOPATH` dynamically using `go env GOPATH` when `go` exists on PATH.

## Revive
Run revive in a Go project:
```bash
revive -config "$HOME/go/revive/.revive.toml" ./...
```

If your symlink target is different, point `-config` to the stowed path in your home directory.

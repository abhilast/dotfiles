# Testing Patterns

**Analysis Date:** 2026-03-18

## Test Framework

**Runner:**
- No dedicated test framework detected
- Manual testing via shell scripts and Bash verification
- Health checks implemented as validation scripts

**Assertion Library:**
- None; validation done via exit codes and manual verification

**Run Commands:**

```bash
# Health check validation
./scripts/health-check.sh                    # Run post-install validation

# ZSH startup time benchmarking
./scripts/benchmark.sh                       # Basic shell startup timing

# Advanced ZSH performance profiling
./scripts/zsh-benchmark-advanced.sh          # Detailed timing analysis

# Shell startup time verification
zsh -i -c exit                               # Time a single startup

# Hyperfine (if installed)
hyperfine --warmup 3 --min-runs 10 'zsh -i -c exit'  # Statistical benchmarking

# Syntax validation
zsh -n zsh/.zshenv zsh/.zshrc                # Check ZSH config syntax

# NVim plugin sync
nvim --headless "+Lazy! sync" +qa            # Install/update plugins

# NVim configuration validation
nvim --headless +"set number" +qa            # Verify NVim loads
```

## Test File Organization

**Location:**
- Tests not co-located with source
- Validation scripts in `scripts/` directory: `health-check.sh`, `benchmark.sh`, `sync.sh`
- No test suite for individual modules

**Naming:**
- Scripts: `descriptive-purpose.sh` (e.g., `health-check.sh`, `profile-zsh-startup.sh`)
- Validation targets marked clearly: health check validates symlinks, dependencies, startup time

**Structure:**
```
scripts/
  ├── health-check.sh        # Post-install verification
  ├── benchmark.sh           # Performance baseline
  ├── sync.sh                # Cross-machine sync validation
  └── [other operational scripts]
```

## Test Structure

**Validation Organization (from `scripts/health-check.sh`):**

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "🔍 Dotfiles Health Check"
echo "========================"

# Check 1: Stow conflicts
echo "→ Checking for Stow conflicts..."
find ~ -maxdepth 3 -name "*.stow-*" 2>/dev/null | while read -r conflict; do
    echo "  ⚠️  Conflict: $conflict"
done

# Check 2: Verify symlinks
echo "→ Verifying symlinks..."
for dir in */; do
    [[ "$dir" == ".git/" || "$dir" == "scripts/" ]] && continue
    target="$HOME/.config/${dir%/}"
    if [[ -L "$target" ]]; then
        if [[ ! -e "$target" ]]; then
            echo "  ❌ Broken: $target"
        else
            echo "  ✅ Valid: $target"
        fi
    fi
done

# Check 3: Dependencies
echo "→ Checking dependencies..."
while IFS= read -r dep; do
    if command -v "$dep" &>/dev/null; then
        echo "  ✅ $dep"
    else
        echo "  ❌ Missing: $dep"
    fi
done < <(grep '^brew "' Brewfile | awk -F'"' '{print $2}')
```

**Patterns:**
- Section-based: Each check marked with `echo "→ Description"`
- Emoji-based status: `✅` pass, `❌` fail, `⚠️ ` warning
- Early exit on critical failures
- Per-item status reporting rather than aggregate

## Mocking

**Framework:** None

**Patterns:**
- Shell functions test external commands via `command -v` availability checks
- Environment variable overrides for testing (e.g., `WT_ROOT`, `WT_REMOTE_BASE` in `scripts/wt`)
- Conditional logic based on OS/platform detection

Example from `scripts/health-check.sh`:
```bash
if [[ ! -e "$target" ]]; then
    echo "  ❌ Broken: $target"
else
    echo "  ✅ Valid: $target"
fi
```

**What to Mock:**
- External commands: use `command -v` to detect availability
- System paths: use environment variables (`$HOME`, `$WORKSPACE`) for portability
- Git operations: initialize test repos with `git init` or use fixtures

**What NOT to Mock:**
- Core system calls (mkdir, cd, etc.)
- Local file system operations (testing actual symlink creation)
- Actual Homebrew operations (tested as integration with real environment)

## Fixtures and Factories

**Test Data:**

Not structured as reusable fixtures. Each validation script embeds its own expectations:

From `scripts/benchmark.sh`:
```bash
# Cold start (clear cache)
echo "Cold start times:"
for i in {1..5}; do
    /usr/bin/time -p zsh -i -c 'exit' 2>&1 | grep real | awk '{print "  Run '$i': " $2 "s"}'
done

# Warm start
echo -e "\nWarm start times:"
for i in {1..5}; do
    /usr/bin/time -p zsh -i -c 'exit' 2>&1 | grep real | awk '{print "  Run '$i': " $2 "s"}'
done
```

**Location:**
- Configuration defaults embedded in scripts themselves
- Environment variable defaults in `install.sh` and `.zshenv`
- No separate fixture directory

## Coverage

**Requirements:** None enforced

**View Coverage:**
- No code coverage tooling
- Validation is binary: symlinks are valid or broken, dependencies are installed or missing
- Performance validated by timing benchmarks in `benchmark.sh`

## Test Types

**Unit Tests:**
- None implemented
- Individual shell functions can be tested by sourcing `.zsh_functions` and calling directly
- Lua config can be tested by requiring modules directly in NVim

Example pattern (manual):
```bash
# Source the functions
source ~/.zsh_functions

# Test a function
result=$(mkcd /tmp/test-dir)
[[ -d /tmp/test-dir ]] && echo "✅ mkcd works"
```

**Integration Tests:**
- `health-check.sh` validates the entire setup post-installation
- Tests symlink creation (stow integration)
- Tests dependency availability (Homebrew integration)
- Tests ZSH startup performance

**E2E Tests:**
- None defined
- Manual validation: `./install.sh` followed by `./scripts/health-check.sh`
- Startup time verification: `./scripts/benchmark.sh` or `./scripts/profile-zsh-startup.sh`

## Common Patterns

**Async Testing:**
- Not applicable; shell scripts are synchronous

**Error Testing:**

Pattern from `.zsh_functions`:
```bash
extract() {
  [[ $# -eq 0 ]] && { echo "Usage: extract <file>"; return 1; }
  [[ ! -f "$1" ]] && { echo "Error: File '$1' not found"; return 1; }

  case "$1" in
    *.tar.bz2|*.tbz2) tar -xjf "$1" ;;
    *)                echo "Error: Unsupported format '$1'"; return 1 ;;
  esac
}
```

Pattern for command availability:
```bash
if command -v docker >/dev/null 2>&1; then
  # Docker is available
else
  echo "❌ Docker not installed"
  return 1
fi
```

**Validation Checklist Pattern (from `health-check.sh`):**

```bash
# For each symlink, check if it's valid
for dir in */; do
    [[ "$dir" == ".git/" || "$dir" == "scripts/" ]] && continue
    target="$HOME/.config/${dir%/}"
    if [[ -L "$target" ]]; then
        if [[ ! -e "$target" ]]; then
            echo "  ❌ Broken: $target"  # Test failed
        else
            echo "  ✅ Valid: $target"   # Test passed
        fi
    fi
done
```

## Performance Testing

**Benchmarking Tools:**

From `scripts/benchmark.sh`:
```bash
if command -v hyperfine &>/dev/null; then
    echo "Using hyperfine for accurate measurements..."
    hyperfine --warmup 3 --min-runs 10 'zsh -i -c exit'
else
    echo "Falling back to basic timing..."
    /usr/bin/time -p zsh -i -c 'exit' 2>&1 | grep real
fi
```

**Profiling:**

From `scripts/profile-zsh-startup.sh`:
```bash
PROFILE_STARTUP=true zsh -i -c 'exit' 2>&1
```

Outputs timing breakdown of plugins and initialization steps.

## Validation Philosophy

Rather than formal test suites, validation emphasizes:

1. **Post-installation checks** (`health-check.sh`): Ensures symlinks are correct, dependencies exist
2. **Performance baselines** (`benchmark.sh`): Tracks shell startup time with multiple runs
3. **Configuration syntax** (`zsh -n`): Validates shell config syntax without execution
4. **Integration verification** (`sync.sh`): Tests the full sync workflow (git pull, brew bundle, stow)

Success criteria:
- All symlinks valid (no broken links)
- All Homebrew dependencies installed
- ZSH startup < target time
- No syntax errors in configs

---

*Testing analysis: 2026-03-18*

# Dotfiles Copilot Instructions

## Repository Overview

This is a macOS-focused dotfiles repository with an automated installation system. The primary architecture uses a trait-based pattern where scripts source common functionality from reusable modules.

## Core Architecture

### Entry Points & Workflow

- **`install`**: Main installer script (POSIX sh) - clones repo, installs dependencies, bootstraps system
- **`suit`**: Main CLI tool (bash) - provides commands: `install`, `setup`, `update`, `selfupdate`
- **Typical workflow**: `install` → `suit install` → `suit setup` (then `suit update` for maintenance)

### Module System (Trait Pattern)

All implementation scripts follow this pattern:

```bash
source "$DOTFILES_HOME/trait.rc"

install() { ... }
setup() { ... }
update() { ... }
sync() { ... }

main "$@"
```

**Key modules**:

- **`trait.rc`**: Base template defining the install/setup/update/sync lifecycle hooks
- **`helper.rc`**: Shared utilities (`message`, `run_file`, `run_directory`, `set_variable`)
- **`shell.rc`**: Common shell configuration (aliases, LS_COLORS, GREP_OPTIONS, etc.)

### Execution Flow

1. `suit` sources `helper.rc` and sets `DOTFILES_HOME`, `OS_NAME`, `OS_VERSION`
2. `suit install` → runs `.scripts/macOS.sh install` → recursively runs `.scripts/{common,macOS}/*.sh install`
3. Each `.sh` script sources `trait.rc` (which sources `helper.rc`) and implements lifecycle functions
4. Scripts use `run_file` and `run_directory` helpers with automatic retry logic (`RETRY`, `RETRY_TIMES`)

## Project Structure

```
install                     # POSIX sh installer (runs before git clone)
suit                        # Main CLI (bash) - sources helper.rc
trait.rc                    # Base trait template - sources helper.rc
helper.rc                   # Shared utilities (message, run_file, etc.)
shell/shell.rc              # Common shell config (sourced by bash/zsh)
.scripts/
  macOS.sh                  # macOS orchestrator - sources trait.rc
  common/*.sh               # Cross-platform scripts (git, vim, tmux, zsh, bash)
  macOS/*.sh                # macOS-specific scripts (node, python, ruby, rust, go, asdf, iterm2, vagrant)
macOS/
  homebrew/Brewfile         # Homebrew bundle (apps + formulae + casks + mas)
  iterm2/profiles.json      # iTerm2 configuration
  sudoers                   # Custom sudoers file (symlinked to /private/etc/sudoers.d/)
shell/
  zsh/zinit.zshrc           # Zinit plugin manager config
  bash/.bashrc              # Bash configuration
vim/LazyVim/                # Neovim LazyVim configuration
git/
  .gitignore_global         # Global git excludes
  lazygit/config.yml        # Lazygit UI config (uses delta pager)
```

## Development Conventions

### Shell Scripts

- **Portability**: Use POSIX sh for `install` script only; bash for everything else
- **Shellcheck**: All scripts include `# shellcheck shell=bash` or `# shellcheck disable=...` directives
- **Messaging**: Use `message --info|--success|--error|--section|--warning` from `helper.rc`
- **Retry logic**: Scripts run via `run_file` automatically retry on failure if `RETRY=true`
- **Environment**: Always check `$DOTFILES_HOME`, `$OS_NAME`, `$OS_VERSION` are set

### Adding New Components

1. Create `.scripts/{common,macOS}/your-tool.sh` with trait pattern
2. Implement `install()`, `setup()`, `update()` functions as needed
3. Will auto-execute via `run_directory` in `macOS.sh`
4. Add dependencies to `macOS/homebrew/Brewfile` if needed

### Brewfile Structure

- Organized with comments: `# Taps`, `# Casks`, `# Formulae`
- Use `cask_args no_quarantine: true` globally
- Use `brew "vendor/tap/formula"` for custom taps
- Xcode is installed separately via `mas` with special handling (`HOMEBREW_BUNDLE_MAS_SKIP`)

### Environment Variables

- Store secrets in `~/Documents/.env` (or specify with `--dotenv-file`)
- `.env` is symlinked to `$DOTFILES_HOME/.env` during install
- Expected vars: `GIT_USER_NAME`, `GIT_USER_EMAIL`

### Version Managers

- **Node**: nodenv with custom aliases plugin (`manlao/tap/node-build-aliases`, `manlao/tap/nodenv-auto-install`)
- **Python**: pyenv + uv + pipx
- **Ruby**: rbenv
- **Go**: goenv
- **Java**: jenv
- **Rust**: rustup-init
- All follow pattern: initialize → check/update versions in lifecycle hooks

## macOS-Specific Behavior

- Uses `caffeinate -u` to prevent sleep during installation
- Installs Xcode Command Line Tools automatically if missing
- Sets ComputerName and LocalHostName during setup
- Configures Touch ID for sudo (`pam-reattach` + custom sudoers)
- Uses git credential helpers: osxkeychain → oauth → manager (in order)

## Testing Changes

```bash
# Dry run install (won't reboot)
suit install --quiet

# Run specific lifecycle
suit setup    # configuration only
suit update   # update packages/versions

# Update dotfiles repo itself
suit selfupdate
```

## Common Patterns

**Adding a homebrew formula**:

- Add to `macOS/homebrew/Brewfile` under appropriate section
- Run `brew bundle install` or `suit update`

**Adding shell config**:

- Cross-platform: add to `shell/shell.rc`
- Zsh-specific: add to `shell/zsh/*.zshrc` or create new snippet

**Adding git config**:

- Edit `.scripts/common/git.sh` → `setup_git()` function

**Symlinking configs**:

- Use pattern in setup functions: `ln -sf "$DOTFILES_HOME/path/to/config" "$HOME/.config/tool/config"`

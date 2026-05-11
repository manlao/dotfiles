# AGENTS.md

## What this is

macOS dotfiles repo. The `suit` CLI orchestrates install, setup, update, and sync of shell config, editors, version managers, terminals, and system preferences. macOS-only (Darwin).

## Architecture

```
install          # POSIX sh bootstrap: clones repo, runs `suit install`
suit             # bash CLI: dispatches install/setup/update/sync/selfupdate
helper.rc        # shared functions: message, set_variable, run_file, run_directory
trait.rc         # base "trait" every script sources; stubs install/setup/update/sync, loads .env
.scripts/
  macOS.sh       # macOS orchestrator: homebrew, system config, then run_directory on common/ and macOS/
  common/*.sh    # cross-platform components (zsh, bash, git, vim, tmux)
  macOS/*.sh     # macOS-specific components (node, ruby, python, go, rust, iterm2, ghostty, kitty, vagrant, asdf)
```

**Script pattern**: Every `.sh` script sources `trait.rc`, then overrides whichever of `install()`, `setup()`, `update()`, `sync()` it needs. `run_directory` calls `run_file` on each `*.sh` alphabetically, then recurses into subdirectories.

**Config deployment**: Dotfiles are symlinked to `$HOME` or `$HOME/.config` (not copied). Examples: `.zshrc -> shell/zsh/.zshrc`, `.tmux.conf -> tmux/.tmux.conf`, `~/.config/nvim -> vim/LazyVim`.

## Key commands

```shell
suit install              # full install (homebrew, packages, all components) - destructive, prompts for reboot
suit setup                # re-run setup steps only (symlinks, configs, system prefs)
suit update               # update system, homebrew, all components
suit selfupdate           # git pull the dotfiles repo
suit sync                 # cleanup unused homebrew packages
```

`suit` is wrapped via a shell function in `shell/shell.rc` that runs under `caffeinate -u` and auto-reloads the shell config afterward.

## Important files

- `.env` - **gitignored**, symlinked from `$HOME/Documents/.env`. Contains `GIT_USER_NAME`, `GIT_USER_EMAIL`, `GIT_HOSTS_USERS_STRING`, and likely proxy/env vars. Never commit this file.
- `macOS/homebrew/Brewfile` - declarative package list for `brew bundle`. The source of truth for what gets installed.
- `macOS/sudoers` - custom sudoers config (sets `timestamp_timeout = 4320`). Symlinked to `/private/etc/sudoers.d/sudoers` with `chown 0`.

## Style

- 2-space indent, UTF-8, LF line endings (`.editorconfig`)
- Shell scripts: `shellcheck` for linting, `shfmt` for formatting, `switch_case_indent = true`
- All scripts use `#!/usr/bin/env bash` except the `install` bootstrap which uses `#!/usr/bin/env sh` (POSIX)
- `set -e` is used in `install` but **not** in `suit` or component scripts

## Shell setup

- **Primary shell**: zsh (Homebrew zsh, not system), plugin manager is **zinit** (`ZSH_PLUGIN_MANAGER` env var)
- **Theme**: Powerlevel10k
- **Key plugins**: fzf-tab, zsh-completions, zsh-autosuggestions, fast-syntax-highlighting, forgit, alias-tips, thefuck
- **Bash**: bash-it framework, mostly secondary
- Shell config chain: `.zshrc` -> `zinit.zshrc` (loads plugins, lazy-loads `shell/shell.rc`) -> `shell.rc` (common env/aliases) -> `macOS.rc` (PATH, version managers, functions)

## Version managers

All use `*env` pattern (not asdf, though asdf is installed):

- **Node**: `nodenv` (with custom `manlao/tap/node-build-aliases` and `manlao/tap/nodenv-auto-install`)
- **Ruby**: `rbenv`
- **Python**: `pyenv` (plus `pipx` for CLI tools, `uv` installed)
- **Go**: `goenv`
- **Java**: `jenv`
- **Rust**: `rustup` (not a *env manager)

## Editors

- **vim**: vim-plug, `.vimrc` at `vim/.vimrc`
- **neovim**: LazyVim config at `vim/LazyVim/`, symlinked to `~/.config/nvim`
- `VISUAL` and `EDITOR` are both set to `nvim`
- Git core.editor is `nvim`

## Containers

Docker runs through **colima** (not Docker Desktop). The `docker()` shell function auto-starts colima if not running. Docker socket is symlinked to `$HOME/.docker/run/docker.sock` and `/var/run/docker.sock`.

## Conventions to follow

- New components: create a `.sh` file in `.scripts/common/` or `.scripts/macOS/`, source `trait.rc`, implement the lifecycle functions you need
- Config files go in their category directory (`shell/`, `git/`, `vim/`, `tmux/`, `macOS/<app>/`) and get symlinked in the corresponding setup script
- Use `message --info`, `message --success`, `message --error` for output (from `helper.rc`)
- Use `run_file` / `run_directory` to invoke sub-scripts with retry support
- `gitclone <url>` organizes clones into `~/Repositories/<domain>/<owner>/<repo>` and sets per-host git user config from `GIT_HOSTS_USERS_STRING`

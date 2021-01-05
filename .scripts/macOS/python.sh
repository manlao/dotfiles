#!/usr/bin/env bash

# shellcheck disable=SC1090
source "$DOTFILES_HOME/trait.rc"

install() {
  install_pyenv
  initialize_pyenv
  install_python
  install_global_packages
}

install_pyenv() {
  if ! brew list pyenv 1>/dev/null 2>&1; then
    message --info "Install homebrew formula: pyenv"
    brew install pyenv
  fi
}

install_python() {
  local LATEST
  LATEST=$(pyenv install --list | grep -v "-" | grep -i -v "[A-Z]" | tail -1 | sed -E -e 's/[ ]//g')

  if ! pyenv versions --bare | grep "$LATEST" 1>/dev/null 2>&1; then
    message --info "Install python"
    pyenv install -s "$LATEST"
  fi
}

install_global_packages() {
  pyenv global "$(pyenv versions --bare | tail -n 1)"

  local PKGS=(
    "neovim"
    "pynvim"
  )
  local P

  for P in "${PKGS[@]}"; do
    if ! pip show "$P" 1>/dev/null 2>&1; then
      message --info "Install global python package: $P"
      pip install "$P"
    fi
  done

  message --info "Install homebrew python packages"

  # homebrew vim
  local HOMEBREW_PIP
  HOMEBREW_PIP="$(brew --prefix python)/bin/pip3"
  "$HOMEBREW_PIP" install neovim pynvim --no-warn-script-location
}

update() {
  initialize_pyenv
  update_python
  update_global_package
}

update_python() {
  local LOCAL_VERSION REMOTE_VERSION PKGS
  LOCAL_VERSION=$(pyenv versions --bare | tail -n 1)
  REMOTE_VERSION=$(pyenv install --list | grep -v "-" | grep -i -v "[A-Z]" | tail -1 | sed -E -e 's/[ ]//g')
  PKGS=$(pyenv global "$LOCAL_VERSION" 1>/dev/null 2>&1; pip --disable-pip-version-check list --format freeze | cut -f 1 -d '=')

  if ! pyenv versions --bare | grep "$REMOTE_VERSION" 1>/dev/null 2>&1; then
    message --info "Update python"

    pyenv install -s "$REMOTE_VERSION"
    pyenv global "$REMOTE_VERSION"
    echo "$PKGS" | xargs pip install --upgrade
    pyenv uninstall -f "$LOCAL_VERSION"
  fi
}

update_global_package() {
  message --info "Update global python packages"

  pyenv global "$(pyenv versions --bare | tail -n 1)"
  pip --disable-pip-version-check list --format freeze | cut -f 1 -d '=' | xargs pip install --upgrade

  message --info "Update homebrew python packages"

  # homebrew vim
  local HOMEBREW_PIP
  HOMEBREW_PIP="$(brew --prefix python)/bin/pip3"
  "$HOMEBREW_PIP" --disable-pip-version-check list --format freeze | cut -f 1 -d '=' | xargs "$HOMEBREW_PIP" install --upgrade --no-warn-script-location
}

initialize_pyenv() {
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$HOME/.pyenv/shims:$PATH"
  eval "$(pyenv init -)"
}

main "$@"

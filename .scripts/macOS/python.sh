#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$DOTFILES_HOME/trait.rc"

PKGS=(
  "neovim"
  "pynvim"
  "podman-compose"
)

install() {
  install_python
  install_poetry
  install_pyenv
  install_pyenv_plugins
  initialize_pyenv
  install_python_versions
  install_global_packages
}

install_python() {
  if ! brew list python 1>/dev/null 2>&1; then
    message --info "Install homebrew formula: python"
    brew install python
  fi
}

install_poetry() {
  if ! brew list poetry 1>/dev/null 2>&1; then
    message --info "Install homebrew formula: poetry"
    brew install poetry
  fi
}

install_pyenv() {
  if ! brew list pyenv 1>/dev/null 2>&1; then
    message --info "Install homebrew formula: pyenv"
    brew install pyenv
  fi
}

install_pyenv_plugins() {
  if ! brew list pyenv-pip-migrate 1>/dev/null 2>&1; then
    message --info "Install homebrew formula: pyenv-pip-migrate"
    brew install pyenv-pip-migrate
  fi
}

install_python_versions() {
  install_or_update_python_versions
}

install_global_packages() {
  message --info "Install global python packages: ${PKGS[*]}"

  pyenv shell system
  pip install "${PKGS[@]}"
}

update() {
  initialize_pyenv
  update_python_versions
  update_global_packages
}

update_python_versions() {
  install_or_update_python_versions
}

update_global_packages() {
  message --info "Update global python packages"

  pyenv shell system
  pip --disable-pip-version-check list --format freeze | cut -f 1 -d '=' | xargs pip install --upgrade
}

initialize_pyenv() {
  eval "$(pyenv init -)"
}

install_or_update_python_versions() {
  local NEXT
  NEXT=$(pyenv install --list | grep -v "-" | grep -i -v "[A-Z]" | tail -1 | sed -E -e 's/[ ]//g')

  if ! pyenv versions --bare | grep "$NEXT" 1>/dev/null 2>&1; then
    message --info "Install python $NEXT"

    local CURRENT
    CURRENT=$(pyenv versions --bare | grep -v "-" | grep -i -v "[A-Z]" | tail -n 1)

    pyenv install -s "$NEXT"
    pyenv global "$NEXT"

    if [ -n "$CURRENT" ]; then
      pyenv migrate "$CURRENT" "$NEXT"
      pyenv uninstall -f "$CURRENT"
    fi
  fi
}

main "$@"

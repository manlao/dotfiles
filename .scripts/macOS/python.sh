#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$DOTFILES_HOME/trait.rc"

APPS=()

install() {
  install_pipx_apps
  initialize_pyenv
  install_python
}

install_pipx_apps() {
  message --info "Install pipx packages: ${APPS[*]}"

  for APP in "${APPS[@]}"; do
    pipx install "$APP"
  done
}

install_python() {
  install_or_update_python
}

update() {
  update_pipx_apps
  initialize_pyenv
  update_python
}

update_pipx_apps() {
  message --info "Update pipx packages: ${APPS[*]}"

  if ! pipx upgrade-all; then
    pipx reinstall-all
  fi
}

update_python() {
  install_or_update_python

  for VERSION in "${PYTHON_VERSIONS[@]}"; do
    install_or_update_python "$VERSION"
  done
}

initialize_pyenv() {
  eval "$(pyenv init - bash)"
}

install_or_update_python() {
  if [ -n "$1" ]; then
    message --info "Check latest python versions for $1"
  else
    message --info "Check latest python versions"
  fi

  local NEXT

  if [ -n "$1" ]; then
    NEXT=$(pyenv install --list | grep -v "-" | grep -i -v "[A-Z]" | grep "$1" | tail -1 | sed -E -e 's/[ ]//g')
  else
    NEXT=$(pyenv install --list | grep -v "-" | grep -i -v "[A-Z]" | tail -1 | sed -E -e 's/[ ]//g')
  fi

  if ! pyenv versions --bare | grep "$NEXT" 1>/dev/null 2>&1; then
    message --info "Install python $NEXT"

    local CURRENT

    if [ -n "$1" ]; then
      CURRENT=$(pyenv versions --bare | grep -v "-" | grep -i -v "[A-Z]" | grep "$1" | tail -n 1)
    else
      CURRENT=$(pyenv versions --bare | grep -v "-" | grep -i -v "[A-Z]" | tail -n 1)
    fi

    pyenv install -s "$NEXT"

    if [ -z "$1" ]; then
      pyenv global "$NEXT"
    fi

    if [ -n "$CURRENT" ]; then
      pyenv migrate "$CURRENT" "$NEXT"
      pyenv uninstall -f "$CURRENT"
    fi
  fi
}

main "$@"

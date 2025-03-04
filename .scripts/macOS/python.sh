#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$DOTFILES_HOME/trait.rc"

APPS=(
  "pdm"
  "poetry"
  "podman-compose"
)

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
}

initialize_pyenv() {
  eval "$(pyenv init -)"
}

install_or_update_python() {
  message --info "Check python versions"

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

#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$DOTFILES_HOME/trait.rc"

install() {
  install_goenv
  initialize_goenv
  install_go
}

install_goenv() {
  if ! brew list goenv 1>/dev/null 2>&1; then
    message --info "Install homebrew formula: goenv"
    brew install goenv
  fi
}

install_go() {
  install_or_update_go
}

update() {
  initialize_goenv
  update_go
}

update_go() {
  install_or_update_go
}

initialize_goenv() {
  eval "$(goenv init -)"
}

install_or_update_go() {
  local NEXT
  NEXT=$(goenv install --list | grep -v "-" | grep -i -v "[A-Z]" | tail -1 | sed -E -e 's/[ ]//g')

  if ! goenv versions --bare | grep "$NEXT" 1>/dev/null 2>&1; then
    message --info "Install go $NEXT"

    local CURRENT
    CURRENT=$(goenv versions --bare | tail -n 1)

    goenv install -s "$NEXT"
    goenv global "$NEXT"

    if [ -n "$CURRENT" ]; then
      # TODO: migrate packages
      goenv uninstall -f "$CURRENT"
    fi
  fi
}

main "$@"

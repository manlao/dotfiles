#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$DOTFILES_HOME/trait.rc"

install() {
  install_rbenv
  initialize_rbenv
  install_ruby
}

install_rbenv() {
  if ! brew list rbenv 1>/dev/null 2>&1; then
    message --info "Install homebrew formula: rbenv"
    brew install rbenv
  fi
}

install_ruby() {
  install_or_update_ruby
}

update() {
  initialize_rbenv
  update_ruby
}

update_ruby() {
  install_or_update_ruby
}

initialize_rbenv() {
  eval "$(rbenv init -)"
}

install_or_update_ruby() {
  local NEXT
  NEXT=$(rbenv install --list-all | grep -v "-" | grep -i -v "[A-Z]" | tail -1 | sed -E -e 's/[ ]//g')

  if ! rbenv versions --bare | grep "$NEXT" 1>/dev/null 2>&1; then
    message --info "Install ruby $NEXT"

    local CURRENT
    CURRENT=$(rbenv versions --bare | tail -n 1)

    rbenv install -s "$NEXT"
    rbenv global "$NEXT"

    if [ -n "$CURRENT" ]; then
      # TODO: migrate packages
      rbenv uninstall -f "$CURRENT"
    fi
  fi
}

main "$@"

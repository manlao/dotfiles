#!/usr/bin/env bash

# shellcheck disable=SC1090
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
  local LATEST
  LATEST=$(rbenv install --list-all | grep -v "-" | grep -i -v "[A-Z]" | tail -1 | sed -E -e 's/[ ]//g')

  if ! rbenv versions --bare | grep "$LATEST" 1>/dev/null 2>&1; then
    message --info "Install ruby"
    rbenv install -s "$LATEST"
  fi
}

update() {
  initialize_rbenv
  update_ruby
}

update_ruby() {
  local LOCAL_VERSION REMOTE_VERSION
  LOCAL_VERSION=$(rbenv versions --bare | tail -n 1)
  REMOTE_VERSION=$(rbenv install --list-all | grep -v "-" | grep -i -v "[A-Z]" | tail -1 | sed -E -e 's/[ ]//g')

  if ! rbenv versions --bare | grep "$REMOTE_VERSION" 1>/dev/null 2>&1; then
    message --info "Update ruby"

    rbenv install -s "$REMOTE_VERSION"
    rbenv global "$REMOTE_VERSION"
    rbenv uninstall -f "$LOCAL_VERSION"
  fi
}

initialize_rbenv() {
  export RBENV_ROOT="$HOME/.rbenv"
  export PATH="$HOME/.rbenv/shims:$PATH"
  eval "$(rbenv init -)"
}

main "$@"

#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$DOTFILES_HOME/trait.rc"

install() {
  install_rust
}

install_rust() {
  if ! rustup 1>/dev/null 2>&1; then
    message --info "Init rustup"
    rustup-init -y --no-modify-path
  fi
}

update() {
  update_rust
}

update_rust() {
  message --info "Update rust"
  rustup update
}

main "$@"

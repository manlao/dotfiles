#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$DOTFILES_HOME/trait.rc"

install() {
  install_rust
}

install_rust() {
  message --info "Init stable rust"
  rustup default stable
}

update() {
  update_rust
}

update_rust() {
  message --info "Update rust"
  rustup update
}

main "$@"

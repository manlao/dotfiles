#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$DOTFILES_HOME/trait.rc"

setup() {
  setup_ghostty
}

setup_ghostty() {
  message --info "Set up ghostty"

  ln -sf "$DOTFILES_HOME/macOS/ghostty" "$HOME/.config/ghostty"
}

main "$@"

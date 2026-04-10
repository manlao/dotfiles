#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$DOTFILES_HOME/trait.rc"

setup() {
  setup_kitty
}

setup_kitty() {
  message --info "Set up kitty"

  ln -sfn "$DOTFILES_HOME/macOS/kitty" "$HOME/.config/kitty"
}

main "$@"

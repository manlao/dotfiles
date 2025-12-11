#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$DOTFILES_HOME/trait.rc"

install() {
  initialize_nodenv
  install_node
}

install_node() {
  install_or_update_node
}

setup() {
  setup_husky
}

setup_husky() {
  message --info "Set up husky"

  mkdir -p "$HOME/.config/husky"
  ln -sf "$DOTFILES_HOME/macOS/node/.huskyrc" "$HOME/.config/husky/init.sh"
}

update() {
  initialize_nodenv
  update_node
}

update_node() {
  install_or_update_node
}

initialize_nodenv() {
  eval "$(nodenv init -)"
}

install_or_update_node() {
  message --info "Check node versions"

  nodenv aliases --update --upgrade-and-enable-corepack
}

main "$@"

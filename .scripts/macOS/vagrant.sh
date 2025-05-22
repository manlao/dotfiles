#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$DOTFILES_HOME/trait.rc"

PLUGINS=(
  "vagrant-timezone"
  "vagrant_utm"
)

install() {
  install_vagrant_plugins
}

install_vagrant_plugins() {
  for P in "${PLUGINS[@]}"; do
    if ! vagrant plugin list | grep "$P" 1>/dev/null 2>&1; then
      message --info "Install vagrant plugin: $P"
      vagrant plugin install "$P"
    fi
  done
}

setup() {
  setup_vagrant
}

setup_vagrant() {
  message --info "Set up Vagrant"
  ln -sf "$DOTFILES_HOME/macOS/vagrant/Vagrantfile" "$HOME/Vagrantfile"
}

update() {
  update_vagrant_plugins
}

update_vagrant_plugins() {
  message --info "Update vagrant plugins"
  vagrant plugin update
}

main "$@"

#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$DOTFILES_HOME/trait.rc"

PLUGINS=(
  "vagrant-env"
  "vagrant-timezone"
)

install() {
  install_virtualbox
  install_vagrant
  install_vagrant_plugins
}

install_virtualbox() {
  if ! brew list --cask virtualbox 1>/dev/null 2>&1; then
    message --info "Install homebrew cask: virtualbox"
    brew install virtualbox
  fi
}

install_vagrant() {
  if ! brew list --cask vagrant 1>/dev/null 2>&1; then
    message --info "Install homebrew cask: vagrant"
    brew install vagrant
  fi
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

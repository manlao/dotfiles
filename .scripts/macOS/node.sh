#!/usr/bin/env bash

# shellcheck disable=SC1090
source "$DOTFILES_HOME/trait.rc"

install() {
  install_nvm
  initialize_nvm
  install_node
  install_global_packages
}

install_nvm() {
  if ! brew list nvm 1>/dev/null 2>&1; then
    message --info "Install homebrew formula: nvm"
    brew install nvm
  fi
}

install_node() {
  if [ "$(nvm version node)" = "N/A" ]; then
    message --info "Install node"
    nvm install node
  fi
}

install_global_packages() {
  nvm use node 1>/dev/null 2>&1

  # prettier plugins
  # @prettier/plugin-php
  # @prettier/plugin-ruby
  # @prettier/plugin-swift
  # @prettier/plugin-xml
  # prettier-plugin-java
  # prettier-plugin-kotlin
  # prettier-plugin-sh
  local PKGS=(
    "nrm"
    "yarn"
    "yrm"
    "commitizen"
    "cz-conventional-changelog"
    "standard-version"
  )
  local P

  for P in "${PKGS[@]}"; do
    if ! npm list -g "$P" 1>/dev/null 2>&1; then
      message --info "Install global node package: $P"
      npm install -g "$P"
    fi
  done
}

setup() {
  setup_global_packages
}

setup_global_packages() {
  message --info "Set up global node packages"

  ln -sf "$DOTFILES_HOME/macOS/node/.cz.json" "$HOME/.cz.json"
  ln -sf "$DOTFILES_HOME/macOS/node/.versionrc.js" "$HOME/.versionrc.js"
}

update() {
  initialize_nvm
  update_node
  update_global_packages
  update_ltses
}

update_node() {
  local LOCAL_VERSION REMOTE_VERSION
  LOCAL_VERSION=$(nvm version node)
  REMOTE_VERSION=$(nvm version-remote node)

  if [ "$LOCAL_VERSION" != "$REMOTE_VERSION" ]; then
    message --info "Update node"

    nvm install "$REMOTE_VERSION" --reinstall-packages-from="$LOCAL_VERSION" --latest-npm
    nvm uninstall "$LOCAL_VERSION"
  fi
}

update_global_packages() {
  message --info "Update global node packages"

  nvm use node
  npm update -g
}

update_ltses() {
  local LTSES=(
    "argon"
    "boron"
    "carbon"
    "dubnium"
    "erbium"
    "fermium"
  )
  local L LOCAL_VERSION REMOTE_VERSION

  for L in "${LTSES[@]}"; do
    if nvm version "lts/$L" 1>/dev/null 2>&1; then
      LOCAL_VERSION=$(nvm version "lts/$L")
      REMOTE_VERSION=$(nvm version-remote "lts/$L")

      if [ "$LOCAL_VERSION" != "$REMOTE_VERSION" ]; then
        message --info "Update lts/$L"

        nvm install "$REMOTE_VERSION"
        nvm uninstall "$LOCAL_VERSION"
      fi
    fi
  done
}

initialize_nvm() {
  export NVM_DIR="$HOME/.nvm"
  # shellcheck disable=SC1090
  source "$(brew --prefix nvm)/nvm.sh"
}

main "$@"

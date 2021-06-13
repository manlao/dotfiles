#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$DOTFILES_HOME/trait.rc"

# prettier plugins
# @prettier/plugin-php
# @prettier/plugin-ruby
# @prettier/plugin-swift
# @prettier/plugin-xml
# prettier-plugin-java
# prettier-plugin-kotlin
# prettier-plugin-sh
PKGS=(
  "nrm"
  "yarn"
  "yrm"
  "commitizen"
  "cz-conventional-changelog"
  "standard-version"
)

install() {
  install_nodenv
  install_nodenv_plugins
  initialize_nodenv
  install_node
  install_packages
}

install_nodenv() {
  if ! brew list nodenv 1>/dev/null 2>&1; then
    message --info "Install homebrew formula: nodenv"
    brew install nodenv
  fi
}

install_nodenv_plugins() {
  if ! brew list nodenv/nodenv/node-build-update-defs 1>/dev/null 2>&1; then
    message --info "Install homebrew formula: nodenv/nodenv/node-build-update-defs"
    brew install nodenv/nodenv/node-build-update-defs
  fi

  if ! brew list nodenv/nodenv/nodenv-npm-migrate 1>/dev/null 2>&1; then
    message --info "Install homebrew formula: nodenv/nodenv/nodenv-npm-migrate"
    brew install nodenv/nodenv/nodenv-npm-migrate
  fi

  if ! brew list nodenv/nodenv/nodenv-nvmrc 1>/dev/null 2>&1; then
    message --info "Install homebrew formula: nodenv/nodenv/nodenv-nvmrc"
    brew install nodenv/nodenv/nodenv-nvmrc
  fi

  if ! brew list nodenv/nodenv/nodenv-package-json-engine 1>/dev/null 2>&1; then
    message --info "Install homebrew formula: nodenv/nodenv/nodenv-package-json-engine"
    brew install nodenv/nodenv/nodenv-package-json-engine
  fi

  if ! brew list manlao/tap/node-build-aliases 1>/dev/null 2>&1; then
    message --info "Install homebrew formula: manlao/tap/node-build-aliases"
    brew install manlao/tap/node-build-aliases
  fi
}

install_node() {
  install_or_update_node
}

install_packages() {
  message --info "Install node packages: ${PKGS[*]}"
  npm install -g "${PKGS[@]}"
}

setup() {
  setup_packages
}

setup_packages() {
  message --info "Set up node packages"

  ln -sf "$DOTFILES_HOME/macOS/node/.cz.json" "$HOME/.cz.json"
  ln -sf "$DOTFILES_HOME/macOS/node/.versionrc.js" "$HOME/.versionrc.js"
}

update() {
  initialize_nodenv
  update_node
  update_packages
}

update_node() {
  install_or_update_node
}

update_packages() {
  message --info "Update node packages"
  npm update -g
}

initialize_nodenv() {
  eval "$(nodenv init -)"
}

install_or_update_node() {
  message --info "Check node versions"

  local CURRENT

  if [ -n "$DEFAULT_NODE_VERSION" ]; then
    CURRENT=$(nodenv aliases --resolve_definition "$DEFAULT_NODE_VERSION" || echo "")
  else
    CURRENT=$(nodenv versions --bare --skip-aliases | grep -v "-" | grep -i -v "[A-Z]" | tail -n 1)
  fi

  nodenv aliases --update --upgrade --uninstall

  local NEXT

  if [ -n "$DEFAULT_NODE_VERSION" ]; then
    NEXT=$(nodenv aliases --resolve_definition "$DEFAULT_NODE_VERSION")
  else
    NEXT=$(nodenv install --list | grep -v "-" | grep -i -v "[A-Z]" | tail -1 | sed -E -e 's/[ ]//g')
  fi

  if ! nodenv versions --bare --skip-aliases | grep "$NEXT" 1>/dev/null 2>&1; then
    message --info "Install node $NEXT"

    nodenv install -s "$NEXT"
    nodenv global "$NEXT"

    if [ -n "$CURRENT" ] && [ "$CURRENT" != "$NEXT" ]; then
      nodenv migrate "$CURRENT" "$NEXT"
      nodenv uninstall -f "$CURRENT"
    fi
  fi
}

main "$@"

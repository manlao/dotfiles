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

  local DEFAULT_VERSION="${DEFAULT_NODE_VERSION:-node}"

  local CURRENT
  CURRENT=$(nodenv aliases --resolve_definition "$DEFAULT_VERSION" || echo "")

  nodenv aliases --update --upgrade

  local NEXT
  NEXT=$(nodenv aliases --resolve_definition "$DEFAULT_VERSION")

  migrate_node "$NEXT" "$CURRENT"
}

migrate_node() {
  # https://github.com/nodenv/nodenv#nodenv-shell
  export NODENV_VERSION="$1"

  if ! nodenv versions --bare --skip-aliases | grep "$1" 1>/dev/null 2>&1; then
    message --info "Install node $1"

    nodenv install -s "$1"
    npm install -g corepack
    corepack enable npm pnpm yarn
  fi

  if [ -n "$2" ] && [ "$2" != "$1" ]; then
    nodenv migrate "$2" "$1"
    nodenv uninstall -f "$2"
  fi
}

main "$@"

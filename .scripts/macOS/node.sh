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

  local CURRENT
  local NEXT

  if [ -n "$DEFAULT_NODE_VERSION" ]; then
    CURRENT=$(nodenv aliases --resolve_definition "$DEFAULT_NODE_VERSION" || echo "")
  fi

  nodenv aliases --update --upgrade

  if [ -n "$DEFAULT_NODE_VERSION" ]; then
    NEXT=$(nodenv aliases --resolve_definition "$DEFAULT_NODE_VERSION")
  fi

  if [ -n "$NEXT" ]; then
    migrate_node "$NEXT" "$CURRENT"
  fi

  CURRENT=$(nodenv versions --bare --skip-aliases | grep -v "-" | grep -i -v "[A-Z]" | tail -n 1)
  NEXT=$(nodenv install --list | grep -v "-" | grep -i -v "[A-Z]" | tail -1 | sed -E -e 's/[ ]//g')

  if [ -n "$NEXT" ]; then
    migrate_node "$NEXT" "$CURRENT"
  fi

  nodenv global "${DEFAULT_NODE_VERSION:-node}"
}

migrate_node() {
  if ! nodenv versions --bare --skip-aliases | grep "$1" 1>/dev/null 2>&1; then
    message --info "Install node $1"

    nodenv install -s "$1"
    # https://github.com/nodenv/nodenv#nodenv-shell
    export NODENV_VERSION="$1"
    corepack enable npm pnpm yarn

    if [ -n "$2" ] && [ "$2" != "$1" ]; then
      nodenv migrate "$2" "$1"
      nodenv uninstall -f "$2"
    fi
  fi
}

main "$@"

#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$DOTFILES_HOME/trait.rc"

PKGS=(
  "nrm"
  "yrm"
  "commitizen"
  "cz-conventional-changelog"
)

install() {
  install_node
  initialize_nodenv
  install_node
  install_node_packages
}

install_node() {
  install_or_update_node
}

install_node_packages() {
  message --info "Install node packages: ${PKGS[*]}"

  nodenv shell "${DEFAULT_NODE_VERSION:-node}"
  npm install -g "${PKGS[@]}"
}

setup() {
  setup_node_packages
}

setup_node_packages() {
  message --info "Set up node packages"

  ln -sf "$DOTFILES_HOME/macOS/node/.npmrc" "$HOME/.npmrc"
  ln -sf "$DOTFILES_HOME/macOS/node/.cz.json" "$HOME/.cz.json"

  mkdir -p "$HOME/.config/husky"
  ln -sf "$DOTFILES_HOME/macOS/node/.huskyrc" "$HOME/.config/husky/init.sh"
}

update() {
  initialize_nodenv
  update_node
  update_node_packages
}

update_node() {
  install_or_update_node
}

update_node_packages() {
  message --info "Update node packages"

  nodenv shell "${DEFAULT_NODE_VERSION:-node}"
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

  nodenv aliases --update --upgrade

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
    corepack enable 1>/dev/null 2>&1

    if [ -n "$CURRENT" ] && [ "$CURRENT" != "$NEXT" ]; then
      nodenv migrate "$CURRENT" "$NEXT"
      nodenv uninstall -f "$CURRENT"
    fi
  fi
}

main "$@"

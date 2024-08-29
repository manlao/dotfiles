#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$DOTFILES_HOME/trait.rc"

PKGS=(
  "github.com/nao1215/gup"
  "golang.org/x/tools/gopls"
  "github.com/go-delve/delve/cmd/dlv"
)

install() {
  install_goenv
  initialize_goenv
  install_go
}

install_goenv() {
  if ! brew list goenv 1>/dev/null 2>&1; then
    message --info "Install goenv"
    brew install goenv
  fi
}

install_go() {
  install_or_update_go
}

update() {
  initialize_goenv
  update_go
}

update_go() {
  install_or_update_go
}

initialize_goenv() {
  eval "$(goenv init -)"
}

install_or_update_go() {
  message --info "Check go versions"

  export GOENV_GOPATH_PREFIX="$HOME/.go"

  local NEXT
  NEXT=$(goenv install --list | grep -v "-" | grep -i -v "[A-Z]" | tail -1 | sed -E -e 's/[ ]//g')

  if goenv versions --bare | grep "$NEXT" 1>/dev/null 2>&1; then
    message --info "Update go packages"

    if command -v gup 1>/dev/null 2>&1; then
      gup update
    fi
  else
    message --info "Install go $NEXT"

    local CURRENT
    CURRENT=$(goenv versions --bare | grep -v "-" | grep -i -v "[A-Z]" | tail -n 1)

    goenv install -s "$NEXT"
    goenv global "$NEXT"

    message --info "Install go packages"

    for P in "${PKGS[@]}"; do
      go install "$P@latest"
    done

    if [ -n "$CURRENT" ]; then
      goenv uninstall -f "$CURRENT"
      sudo rm -rf "$GOENV_GOPATH_PREFIX/$CURRENT"
    fi
  fi
}

main "$@"

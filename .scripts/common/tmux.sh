#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$DOTFILES_HOME/trait.rc"

install() {
  install_tmux
}

install_tmux() {
  case "$OS_NAME" in
    macOS )
      if ! brew list tmux 1>/dev/null 2>&1; then
        message --info "Install homebrew formula: tmux"
        brew install tmux
      fi
      ;;
  esac
}

setup() {
  setup_tmux
}

setup_tmux() {
  message --info "Set up tmux"
  ln -sf "$DOTFILES_HOME/tmux/.tmux.conf" "$HOME/.tmux.conf"
}

main "$@"

#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$DOTFILES_HOME/trait.rc"

setup() {
  setup_tmux
}

setup_tmux() {
  message --info "Set up tmux"

  mkdir -p "$HOME/.tmux/hooks"

  ln -sf "$DOTFILES_HOME/tmux/.tmux.conf" "$HOME/.tmux.conf"
  ln -sf "$DOTFILES_HOME/tmux/hooks/session-closed.sh" "$HOME/.tmux/hooks/session-closed.sh"
}

main "$@"

#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$DOTFILES_HOME/trait.rc"

BASH_IT_FOLDER="$HOME/.bash_it"

install() {
  install_bash_it
}

install_bash_it() {
  if [ ! -d "$BASH_IT_FOLDER" ]; then
    message --info "Install Bash-it"

    rm -rf "$BASH_IT_FOLDER"
    git clone "https://github.com/Bash-it/bash-it.git" "$BASH_IT_FOLDER"
  fi
}

setup() {
  setup_bash
}

setup_bash() {
  message --info "Set up bash"

  local BASH_BIN

  case "$OS_NAME" in
    macOS)
      BASH_BIN="$(brew --prefix)/bin/bash"
      ;;
  esac

  if [ -n "$BASH_BIN" ] && ! grep "^$BASH_BIN" "/etc/shells" 1>/dev/null 2>&1; then
    echo "$BASH_BIN" | sudo tee -a "/etc/shells"
  fi

  ln -sf "$DOTFILES_HOME/shell/bash/.inputrc" "$HOME/.inputrc"
  ln -sf "$DOTFILES_HOME/shell/bash/.bashrc" "$HOME/.bashrc"
}

update() {
  update_bash_it
}

update_bash_it() {
  message --info "Update Bash-it"
  git -C "$BASH_IT_FOLDER" pull
}

main "$@"

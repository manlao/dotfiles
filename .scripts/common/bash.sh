#!/usr/bin/env bash

# shellcheck disable=SC1090
source "$DOTFILES_HOME/trait.rc"

BASH_IT_FOLDER="$HOME/.bash_it"

install() {
  install_bash
  install_bash_it
}

install_bash() {
  case "$OS_NAME" in
    macOS )
      if ! brew list bash 1>/dev/null 2>&1; then
        message --info "Install homebrew formula: bash"
        brew install bash
      fi
      ;;
    OpenWrt )
      local STATUS
      STATUS=$(opkg status bash)

      if [ -z "$STATUS" ]; then
        message --info "Install opkg package: bash"
        opkg install bash
      fi
      ;;
  esac
}

install_bash_it() {
  if [ ! -d "$BASH_IT_FOLDER" ]; then
    message --info "Clone Bash-it/bash-it"

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
    macOS )
      BASH_BIN="$(brew --prefix)/bin/bash"
      ;;
    OpenWrt )
      BASH_BIN="/bin/bash"
  esac

  if [ -n "$BASH_BIN" ] && ! grep "^$BASH_BIN" "/etc/shells" 1>/dev/null 2>&1; then
    echo "$BASH_BIN" | sudo tee -a "/etc/shells"
  fi

  case "$OS_NAME" in
    OpenWrt )
      message --info "Change default shell to: $BASH_BIN"
      sed -i -r "s/^($USER.*):([^:]*)/\1:${BASH_BIN//\//\\\/}/" /etc/passwd
      ;;
  esac

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

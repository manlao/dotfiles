#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$DOTFILES_HOME/trait.rc"

DOTZSHRC="$DOTFILES_HOME/shell/zsh/.zshrc"
ZSH_PLUGIN_MANAGER="${ZSH_PLUGIN_MANAGER:-zinit}"

install() {
  install_zsh
  "install_${ZSH_PLUGIN_MANAGER//-/_}"
  "install_${ZSH_PLUGIN_MANAGER//-/_}_plugins"
}

install_zsh() {
  case "$OS_NAME" in
    macOS )
      if ! brew list zsh 1>/dev/null 2>&1; then
        message --info "Install zsh"
        brew install zsh
      fi
      ;;
  esac
}

install_zinit() {
  local ZINIT_BIN="$HOME/.zinit/bin"

  if [ ! -d "$ZINIT_BIN" ]; then
    message --info "Install zinit"

    rm -rf "$ZINIT_BIN"
    git clone "https://github.com/zdharma-continuum/zinit.git" "$ZINIT_BIN"
  fi
}

install_zinit_plugins() {
  message --info "Install zsh plugins"
  ZDOTDIR="$DOTFILES_HOME/shell/zsh" zsh -i -c "source $DOTZSHRC; zinit self-update"
}

install_zplug() {
  case "$OS_NAME" in
    macOS )
      if ! brew list zplug 1>/dev/null 2>&1; then
        message --info "Install zplug"
        brew install zplug
      fi
      ;;
  esac
}

install_zplug_plugins() {
  message --info "Install zsh plugins"
  ZDOTDIR="$DOTFILES_HOME/shell/zsh" zsh -i -c "source $DOTZSHRC; zplug check || zplug install"
}

setup() {
  setup_zsh
}

setup_zsh() {
  message --info "Set up zsh"

  local ZSH_BIN

  case "$OS_NAME" in
    macOS )
      ZSH_BIN="$(brew --prefix)/bin/zsh"
      ;;
  esac

  if [ -n "$ZSH_BIN" ] && ! grep "^$ZSH_BIN" "/etc/shells" 1>/dev/null 2>&1; then
    echo "$ZSH_BIN" | sudo tee -a "/etc/shells"
  fi

  case "$OS_NAME" in
    macOS )
      message --info "Change default shell to: $ZSH_BIN"

      chmod g-w "$(brew --prefix)/share/zsh"
      chmod g-w "$(brew --prefix)/share/zsh/site-functions"
      chsh -s "$ZSH_BIN"
      ;;
  esac

  ln -sf "$DOTZSHRC" "$HOME/.zshrc"
}

update() {
  "update_${ZSH_PLUGIN_MANAGER//-/_}_plugins"
}

update_zinit_plugins() {
  message --info "Update zsh plugins"
  zsh -i -c "source $DOTZSHRC; zinit cclear; zinit self-update; zinit update --all"
}

update_zplug_plugins() {
  message --info "Update zsh plugins"
  zsh -i -c "source $DOTZSHRC; zplug update"
}

main "$@"

#!/usr/bin/env bash

# shellcheck disable=SC1090
source "$DOTFILES_HOME/trait.rc"

DOTVIMRC="$DOTFILES_HOME/vim/.vimrc"
VIM_PLUGIN_MANAGER="${VIM_PLUGIN_MANAGER:-vim-plug}"

install() {
  install_vim
  install_neovim
  "install_${VIM_PLUGIN_MANAGER//-/_}"
  "install_${VIM_PLUGIN_MANAGER//-/_}_plugins"
}

install_vim() {
  case "$OS_NAME" in
    macOS )
      if ! brew list vim 1>/dev/null 2>&1; then
        message --info "Install homebrew formula: vim"
        brew install vim
      fi
      ;;
  esac
}

install_neovim() {
  case "$OS_NAME" in
    macOS )
      if ! brew list neovim 1>/dev/null 2>&1; then
        message --info "Install homebrew formula: neovim"
        brew install neovim
      fi
      ;;
  esac
}

install_vim_plug() {
  local VIM_PLUGIN_MANAGER_PATHS=("$HOME/.vim/autoload/plug.vim")

  case "$OS_NAME" in
    macOS )
      VIM_PLUGIN_MANAGER_PATHS+=("$HOME/.local/share/nvim/site/autoload/plug.vim")
      ;;
  esac

  local P

  for P in "${VIM_PLUGIN_MANAGER_PATHS[@]}"; do
    if [ ! -f "$P" ]; then
      message --info "Install vim-plug into $P"

      rm -rf "$P"
      curl -fsSL "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" --create-dirs -o "$P"
    fi
  done
}

install_vim_plug_plugins() {
  message --info "Install vim/neovim plugins"

  vim -u "$DOTVIMRC" +PlugInstall +qall

  case "$OS_NAME" in
    macOS )
      nvim -u "$DOTVIMRC" +PlugInstall +qall
      ;;
  esac
}

setup() {
  setup_vim
}

setup_vim() {
  message --info "Set up vim"

  mkdir -p "$HOME/.vim/.backup"
  mkdir -p "$HOME/.vim/.swp"
  mkdir -p "$HOME/.vim/.undo"

  ln -sf "$DOTVIMRC" "$HOME/.vimrc"
}

update() {
  "update_${VIM_PLUGIN_MANAGER//-/_}_plugins"
}

update_vim_plug_plugins() {
  message --info "Update vim/neovim plugins"

  vim +PlugUpgrade +PlugUpdate +qall

  case "$OS_NAME" in
    macOS )
      nvim +PlugUpgrade +PlugUpdate +qall
      ;;
  esac
}

main "$@"

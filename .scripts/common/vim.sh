#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$DOTFILES_HOME/trait.rc"

DOTVIMRC="$DOTFILES_HOME/vim/.vimrc"
VIM_PLUGIN_MANAGER="${VIM_PLUGIN_MANAGER:-vim-plug}"

install() {
  install_vim
  install_vim_dependencies
  install_neovim
  install_neovim_dependencies
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

install_vim_dependencies() {
  message --info "Install vim dependencies"
  "$(brew --prefix "$(brew deps vim | grep python)")/bin/pip3" install neovim pynvim --no-warn-script-location
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

install_neovim_dependencies() {
  message --info "Install neovim dependencies"
  "$(brew --prefix python)/bin/pip3" install neovim pynvim --no-warn-script-location
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
  update_neovim_dependencies
  "update_${VIM_PLUGIN_MANAGER//-/_}_plugins"
}

update_neovim_dependencies() {
  message --info "Update neovim dependencies"

  local PIP
  PIP="$(brew --prefix python)/bin/pip3"
  "$PIP" --disable-pip-version-check list --format freeze | cut -f 1 -d '=' | xargs "$PIP" install --upgrade --no-warn-script-location
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

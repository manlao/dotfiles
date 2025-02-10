#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$DOTFILES_HOME/trait.rc"

DOTVIMRC="$DOTFILES_HOME/vim/.vimrc"
LAZYVIM="$DOTFILES_HOME/vim/LazyVim"

install() {
  install_vim_plug
  install_vim_plugins
}

install_vim_plug() {
  local P="$HOME/.vim/autoload/plug.vim"

  if [ ! -f "$P" ]; then
    message --info "Install vim-plug into $P"

    rm -rf "$P"
    curl -fsSL "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" --create-dirs -o "$P"
  fi
}

install_vim_plugins() {
  message --info "Install vim plugins"

  vim -u "$DOTVIMRC" +PlugInstall +qall
}

setup() {
  setup_vim
  setup_lazyvim
}

setup_vim() {
  message --info "Set up vim"

  mkdir -p "$HOME/.vim/.backup"
  mkdir -p "$HOME/.vim/.swp"
  mkdir -p "$HOME/.vim/.undo"

  ln -sf "$DOTVIMRC" "$HOME/.vimrc"
}

setup_lazyvim() {
  message --info "Set up LazyVim"

  mkdir -p "$HOME/.config"

  ln -sf "$LAZYVIM" "$HOME/.config/nvim"
}

update() {
  update_lazy_vim
  update_vim_plugins
}

update_lazy_vim() {
  nvim --headless "+Lazy! sync" +qa
}

update_vim_plugins() {
  message --info "Update vim plugins"

  vim +PlugUpgrade +PlugUpdate +qall
}

main "$@"

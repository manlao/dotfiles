#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$DOTFILES_HOME/trait.rc"

DOTVIMRC="$DOTFILES_HOME/vim/.vimrc"
LAZYVIM="$DOTFILES_HOME/vim/LazyVim"
VIM_PLUGIN_MANAGER="${VIM_PLUGIN_MANAGER:-vim-plug}"

DEPS=(
  neovim
  pynvim
)

install() {
  install_vim_dependencies
  install_neovim_dependencies
  "install_${VIM_PLUGIN_MANAGER//-/_}"
  "install_${VIM_PLUGIN_MANAGER//-/_}_plugins"
}

install_vim_dependencies() {
  message --info "Install vim dependencies"
  "$(brew --prefix "$(brew deps vim | grep python)")/libexec/bin/pip" install "${DEPS[@]}" --user --break-system-packages --no-warn-script-location
}

install_neovim_dependencies() {
  message --info "Install neovim dependencies"
  "$(brew --prefix python)/libexec/bin/pip" install "${DEPS[@]}" --user --break-system-packages --no-warn-script-location
}

install_vim_plug() {
  local VIM_PLUGIN_MANAGER_PATHS=("$HOME/.vim/autoload/plug.vim")

  case "$OS_NAME" in
    macOS)
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
    macOS)
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
  ln -sf "$LAZYVIM" "$HOME/.config/nvim"
}

update() {
  update_vim_dependencies
  update_neovim_dependencies
  "update_${VIM_PLUGIN_MANAGER//-/_}_plugins"
}

update_vim_dependencies() {
  message --info "Update vim dependencies"

  local PIP
  PIP="$(brew --prefix "$(brew deps vim | grep python)")/libexec/bin/pip"
  "$PIP" --disable-pip-version-check list | tail -n +3 | cut -f 1 -d ' ' | xargs "$PIP" install --user --break-system-packages --upgrade --no-warn-script-location
}

update_neovim_dependencies() {
  message --info "Update neovim dependencies"

  local PIP
  PIP="$(brew --prefix python)/libexec/bin/pip"
  "$PIP" --disable-pip-version-check list | tail -n +3 | cut -f 1 -d ' ' | xargs "$PIP" install --user --break-system-packages --upgrade --no-warn-script-location
}

update_vim_plug_plugins() {
  message --info "Update vim/neovim plugins"

  vim +PlugUpgrade +PlugUpdate +qall

  case "$OS_NAME" in
    macOS)
      nvim +PlugUpgrade +PlugUpdate +qall
      ;;
  esac
}

main "$@"

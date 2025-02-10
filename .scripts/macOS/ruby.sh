#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$DOTFILES_HOME/trait.rc"

PKGS=(
  "rubocop"
  "cocoapods"
)

install() {
  initialize_rbenv
  install_ruby
  install_ruby_gems
}

install_ruby() {
  install_or_update_ruby
}

install_ruby_gems() {
  message --info "Install ruby gems: ${PKGS[*]}"

  rbenv shell "$(rbenv versions --bare | tail -1)"
  gem install "${PKGS[@]}"
}

update() {
  initialize_rbenv
  update_ruby
  update_ruby_gems
}

update_ruby() {
  install_or_update_ruby
}

update_ruby_gems() {
  message --info "Update ruby gems: ${PKGS[*]}"

  rbenv shell "$(rbenv versions --bare | tail -1)"
  gem update "${PKGS[@]}"
}

initialize_rbenv() {
  eval "$(rbenv init -)"
}

install_or_update_ruby() {
  message --info "Check ruby versions"

  local NEXT
  NEXT=$(rbenv install --list-all | grep -v "-" | grep -i -v "[A-Z]" | tail -1 | sed -E -e 's/[ ]//g')

  if ! rbenv versions --bare | grep "$NEXT" 1>/dev/null 2>&1; then
    message --info "Install ruby $NEXT"

    local CURRENT
    CURRENT=$(rbenv versions --bare | grep -v "-" | grep -i -v "[A-Z]" | tail -n 1)

    rbenv install -s "$NEXT"
    rbenv global "$NEXT"
    rbenv shell "$(rbenv versions --bare | tail -1)"
    gem install "${PKGS[@]}"

    if [ -n "$CURRENT" ]; then
      rbenv uninstall -f "$CURRENT"
    fi
  fi
}

main "$@"

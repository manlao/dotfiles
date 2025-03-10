#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$DOTFILES_HOME/trait.rc"

install_plugins() {
  message --info "Install asdf plugins"

  asdf plugin add Dart
  asdf plugin add Deno
  asdf plugin add Flutter
  asdf plugin add Go
  asdf plugin add Gradle
  asdf plugin add Java
  asdf plugin add Kotlin
  asdf plugin add Node.js
  asdf plugin add PHP
  asdf plugin add Python
  asdf plugin add Ruby
  asdf plugin add Rust
}

update() {
  update_plugins
}

update_plugins() {
  if asdf plugin list 1>/dev/null 2>&1; then
    message --info "Update asdf plugins"
    asdf plugin update --all
  fi
}

main "$@"

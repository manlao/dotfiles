#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$DOTFILES_HOME/trait.rc"

setup() {
  setup_git
  setup_git_flow_avh
  setup_lazygit
}

setup_git() {
  message --info "Set up git"

  if [ -n "$GIT_USER_NAME" ]; then
    git config --global user.name "$GIT_USER_NAME"
  fi

  if [ -n "$GIT_USER_EMAIL" ]; then
    git config --global user.email "$GIT_USER_EMAIL"
  fi

  git config --global core.autocrlf "input"
  git config --global core.editor "vim"
  git config --global core.excludesFile "$DOTFILES_HOME/git/.gitignore_global"
  git config --global core.pager "less -FRSX"
  git config --global color.ui "auto"
  git config --global init.defaultBranch "main"
  git config --global pull.ff "only"
  git config --global submodule.recurse true

  case "$OS_NAME" in
    macOS)
      git config --global --unset-all credential.helper
      git config --global --add credential.helper osxkeychain
      git config --global --add credential.helper "cache --timeout 21600" # six hours
      git config --global --add credential.helper oauth

      local GIT_HOSTS_USERS U SEGMENTS

      read -r -a GIT_HOSTS_USERS <<<"$GIT_HOSTS_USERS_STRING"

      for U in "${GIT_HOSTS_USERS[@]}"; do
        IFS="," read -r -a SEGMENTS <<<"$U"

        git credential-osxkeychain store <<EOF
protocol=${SEGMENTS[2]:-https}
host=${SEGMENTS[0]}
username=${SEGMENTS[3]}
password=${SEGMENTS[1]}
EOF
      done

      local DIR
      DIR="$(brew --prefix git)/share/git-core/templates/hooks"
      local PATTERN="$DOTFILES_HOME/git/hooks/*"
      local FILE

      for FILE in $PATTERN; do
        ln -sf "$FILE" "$DIR/${FILE##*/}"
      done
      ;;
  esac
}

setup_git_flow_avh() {
  message --info "Set up git flow"

  git config --global gitflow.branch.main "main"
  git config --global gitflow.branch.master "main"
  git config --global gitflow.branch.develop "develop"
  git config --global gitflow.prefix.feature "feature/"
  git config --global gitflow.prefix.bugfix "bugfix/"
  git config --global gitflow.prefix.release "release/"
  git config --global gitflow.prefix.hotfix "hotfix/"
  git config --global gitflow.prefix.support "support/"
  git config --global gitflow.prefix.versiontag "v"
}

setup_lazygit() {
  message --info "Set up lazygit"

  case "$OS_NAME" in
    macOS)
      ln -sf "$DOTFILES_HOME/git/lazygit/config.yml" "$HOME/Library/Application Support/lazygit/config.yml"
      ;;
  esac
}

main "$@"

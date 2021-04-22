#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$DOTFILES_HOME/trait.rc"

install() {
  install_git
  install_git_flow_avh
}

install_git() {
  case "$OS_NAME" in
    macOS )
      if ! brew list git 1>/dev/null 2>&1; then
        message --info "Install homebrew formula: git"
        brew install git
      fi
      ;;
  esac
}

install_git_flow_avh() {
  case "$OS_NAME" in
    macOS )
      if ! brew list git-flow-avh 1>/dev/null 2>&1; then
        message --info "Install homebrew formula: git-flow-avh"
        brew install git-flow-avh
      fi
      ;;
  esac
}

setup() {
  setup_git
  setup_git_flow_avh
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
  git config --global core.excludesfile "$DOTFILES_HOME/git/.gitignore_global"
  git config --global core.pager "less -FRSX"
  git config --global color.ui "auto"
  git config --global init.defaultBranch "main"
  git config --global pull.ff "only"
  git config --global submodule.recurse true

  case "$OS_NAME" in
    macOS )
      git config --global credential.helper osxkeychain

      local H SEGMENTS

      for H in "${GIT_HOSTS[@]}"; do
        IFS="," read -r -a SEGMENTS <<< "$H"

        git credential-osxkeychain store <<EOF
protocol=${SEGMENTS[2]:-https}
host=${SEGMENTS[0]}
username=${SEGMENTS[3]:-$GIT_USER}
password=${SEGMENTS[1]}
EOF
      done

      cp -rf "$DOTFILES_HOME/git/hooks" "$(brew --prefix git)/share/git-core/templates"
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
  git config --global gitflow.prefix.versiontag ""
}

main "$@"

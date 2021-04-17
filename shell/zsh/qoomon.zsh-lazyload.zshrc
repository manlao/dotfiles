case "$OS_NAME" in
  macOS )
    # asdf
    load:asdf() {
      source "$HOMEBREW_PREFIX/opt/asdf/asdf.sh"
    }

    lazyload asdf -- load:asdf

    # nvm
    load:nvm() {
      export NVM_DIR="$HOME/.nvm"
      source "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
    }

    lazyload nvm -- load:nvm

    # pyenv
    load:pyenv() {
      export PYENV_ROOT="$HOME/.pyenv"
      eval "$(pyenv init -)"
    }

    lazyload pyenv -- load:pyenv

    # rbenv
    load:rbenv() {
      export RBENV_ROOT="$HOME/.rbenv"
      eval "$(rbenv init -)"
    }

    lazyload rbenv -- load:rbenv

    # jenv
    load:jenv() {
      eval "$(jenv init -)"
    }

    lazyload jenv -- load:jenv

    # docker
    load:docker() {
      if ! docker info 1>/dev/null 2>&1; then
        open -g -a "/Applications/Docker.app"

        while ! docker info 1>/dev/null 2>&1; do
          sleep 5
        done
      fi
    }

    lazyload docker docker-compose kubectl minikube kubeadm kubelet -- load:docker

    # the fuck
    load:fuck() {
      eval "$(thefuck --alias)"
    }

    lazyload fuck -- load:fuck
    ;;
esac

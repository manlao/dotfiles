case "$OS_NAME" in
  macOS )
    # asdf
    load:asdf() {
      source "$(brew --prefix asdf)/asdf.sh"
    }

    lazyload asdf -- load:asdf

    # nvm
    load:nvm() {
      export NVM_DIR="$HOME/.nvm"
      # shellcheck disable=SC1090
      source "$(brew --prefix nvm)/nvm.sh"
    }

    lazyload nvm node npm npx yarn cz git-cz commitizen standard-version -- load:nvm

    # pyenv
    load:pyenv() {
      export PYENV_ROOT="$HOME/.pyenv"
      eval "$(pyenv init -)"
    }

    lazyload pyenv python python3 pip pip3 pipenv -- load:pyenv

    # rbenv
    load:rbenv() {
      export RBENV_ROOT="$HOME/.rbenv"
      eval "$(rbenv init -)"
    }

    lazyload rbenv ruby -- load:rbenv

    # jenv
    load:jenv() {
      eval "$(jenv init -)"
    }

    lazyload jenv java -- load:jenv

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

case "$OS_NAME" in
  macOS )
    # podman
    load:podman() {
      if ! vagrant status --machine-readable | grep "podman,state,running" 1>/dev/null 2>&1; then
        vagrant up podman
      fi
    }

    lazyload podman podman-compose -- load:podman

    # docker
    load:docker() {
      if ! docker info 1>/dev/null 2>&1; then
        open -g -a "/Applications/Docker.app"

        while ! docker info 1>/dev/null 2>&1; do
          sleep 5
        done
      fi
    }

    lazyload docker docker-compose -- load:docker

    # the fuck
    load:fuck() {
      eval "$(thefuck --alias)"
    }

    lazyload fuck -- load:fuck
    ;;
esac

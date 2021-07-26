case "$OS_NAME" in
  macOS )
    # the fuck
    load:fuck() {
      eval "$(thefuck --alias)"
    }

    lazyload fuck -- load:fuck
    ;;
esac

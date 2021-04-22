case "$OS_NAME" in
  macOS )
    export ZPLUG_HOME="$HOMEBREW_PREFIX/opt/zplug"
    ;;
esac

source "$ZPLUG_HOME/init.zsh"

# https://github.com/zplug/zplug/issues/419
alias zplug="LC_ALL=en_US.UTF-8 zplug"

# oh-my-zh libs
zplug "lib/completion", from:oh-my-zsh
zplug "lib/key-bindings", from:oh-my-zsh
zplug "lib/spectrum", from:oh-my-zsh

# oh-my-zsh plugins
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/extract", from:oh-my-zsh

# plugins
# zplug "Aloxaf/fzf-tab"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "djui/alias-tips"
# zplug "b4b4r07/emoji-cli"
# zplug "b4b4r07/enhancd"
# zplug "xav-b/zsh-extend-history"
# zplug "wfxr/forgit"
zplug "qoomon/zsh-lazyload", hook-load:"source $ZSH_DIR/qoomon.zsh-lazyload.zshrc"
# zplug "shihyuho/zsh-jenv-lazy"
# zplug "supercrabtree/k"
# zplug "gko/listbox"
# zplug "iboyperson/zsh-pipenv"
# zplug "laggardkernel/zsh-thefuck"
# zplug "sinetoami/web-search"
# zplug "agkozak/zsh-z"

# plugins by os
# case "$OS_NAME" in
#   macOS )
#     zplug "pndurette/zsh-lux"
#     ;;
# esac

# themes
zplug "romkatv/powerlevel10k", as:theme, use:powerlevel10k.zsh-theme, hook-load:"source $ZSH_DIR/romkatv.powerlevel10k.zshrc; source $ZSH_DIR/romkatv.powerlevel10k.custom.zshrc"

# syntax highlighting
# zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zdharma/fast-syntax-highlighting", defer:2

# Install plugins if there are plugins that have not been installed
# if ! zplug check; then
#   zplug install
# fi

# Then, source plugins and add commands to $PATH
zplug load

zsh-compinit

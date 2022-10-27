export ZINIT_HOME="$HOME/.zinit"

source "$ZINIT_HOME/bin/zinit.zsh"

# oh-my-zh libs
zinit snippet OMZL::completion.zsh
zinit snippet OMZL::key-bindings.zsh
zinit snippet OMZL::spectrum.zsh

# oh-my-zsh plugins
zinit snippet OMZP::colored-man-pages
zinit snippet OMZP::extract

# plugins
# zinit light "Aloxaf/fzf-tab"
zinit light "zsh-users/zsh-completions"
zinit light "zsh-users/zsh-autosuggestions"
zinit light "djui/alias-tips"
# zinit light "b4b4r07/emoji-cli"
# zinit light "b4b4r07/enhancd"
# zinit light "xav-b/zsh-extend-history"
# zinit light "wfxr/forgit"
zinit ice atload"source $ZSH_DIR/qoomon.zsh-lazyload.zshrc"
zinit light "qoomon/zsh-lazyload"
# zinit light "shihyuho/zsh-jenv-lazy"
# zinit light "supercrabtree/k"
# zinit light "gko/listbox"
# zinit light "iboyperson/zsh-pipenv"
# zinit light "laggardkernel/zsh-thefuck"
# zinit light "sinetoami/web-search"
# zinit light "agkozak/zsh-z"

# plugins by os
# case "$OS_NAME" in
#   macOS )
#     zinit light "pndurette/zsh-lux"
#     ;;
# esac

# themes
zinit ice atload"source $ZSH_DIR/romkatv.powerlevel10k.zshrc; source $ZSH_DIR/romkatv.powerlevel10k.custom.zshrc"
zinit light "romkatv/powerlevel10k"

# syntax highlighting
zinit ice atinit"zsh-compinit"
# zinit light "zsh-users/zsh-syntax-highlighting"
zinit light "zdharma-continuum/fast-syntax-highlighting"

zinit ice wait lucid
zinit snippet "$DOTFILES_HOME/shell/shell.rc"

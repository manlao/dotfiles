# shellcheck shell=bash

#=======================================================================#
# variables, sources, aliases                                           #
#=======================================================================#

export SH="bash"

if [ -L "${BASH_SOURCE[0]}" ]; then
  DOTBASHRC=$(readlink "${BASH_SOURCE[0]}")
else
  DOTBASHRC="${BASH_SOURCE[0]}"
fi

BASH_DIR="${DOTBASHRC%/*}"
DOTFILES_HOME="${BASH_DIR%/*/*}"

export DOTBASHRC
export BASH_DIR
export DOTFILES_HOME

if [ -f "$DOTFILES_HOME/.env" ]; then
  # shellcheck disable=SC1091
  source "$DOTFILES_HOME/.env"
fi

# shellcheck disable=SC1091
source "$DOTFILES_HOME/shell/shell.rc"

#=======================================================================#
# bash-it                                                               #
#=======================================================================#

# Path to the bash it configuration
export BASH_IT="$HOME/.bash_it"

# Lock and Load a custom theme file.
# Leave empty to disable theming.
# location /.bash_it/themes/
case "$OS_NAME" in
  macOS )
    export BASH_IT_THEME="powerline-multiline"
    export THEME_CLOCK_FORMAT="%Y-%m-%d %H:%M:%S"
    export POWERLINE_PROMPT_USER_INFO_MODE="sudo"
    export POWERLINE_PADDING=0
    export POWERLINE_PROMPT="user_info cwd scm last_status"
    export POWERLINE_LEFT_PROMPT="user_info cwd scm"
    export POWERLINE_RIGHT_PROMPT="last_status"
    ;;
  * )
    export BASH_IT_THEME="sexy"
    ;;
esac

# (Advanced): Change this to the name of your remote repo if you
# cloned bash-it with a remote other than origin such as `bash-it`.
# export BASH_IT_REMOTE='bash-it'

# Don't check mail when opening terminal.
unset MAILCHECK

# Set this to false to turn off version control status checking within the
# prompt for all themes
export SCM_CHECK=true

# Set Xterm/screen/Tmux title with only a short hostname.
# Uncomment this (or set SHORT_HOSTNAME to something else),
# Will otherwise fall back on $HOSTNAME.
#export SHORT_HOSTNAME=$(hostname -s)

# Set Xterm/screen/Tmux title with only a short username.
# Uncomment this (or set SHORT_USER to something else),
# Will otherwise fall back on $USER.
#export SHORT_USER=${USER:0:8}

# Set Xterm/screen/Tmux title with shortened command and directory.
# Uncomment this to set.
#export SHORT_TERM_LINE=true

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/djl/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# (Advanced): Uncomment this to make Bash-it reload itself automatically
# after enabling or disabling aliases, plugins, and completions.
# export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1

# Uncomment this to make Bash-it create alias reload.
# export BASH_IT_RELOAD_LEGACY=1

# Load Bash It
# shellcheck disable=SC1091
source "$BASH_IT/bash_it.sh"

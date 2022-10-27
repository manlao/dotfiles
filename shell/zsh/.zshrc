# shellcheck shell=zsh

#=======================================================================#
# zsh profiling                                                         #
#=======================================================================#

if [ "$ZSH_PROFILING" = true ]; then
  zmodload zsh/zprof
fi

#=======================================================================#
# set options                                                           #
#=======================================================================#

# Changing Directories
setopt AUTO_CD
setopt AUTO_PUSHD
setopt CDABLE_VARS
# setopt CHASE_DOTS
# setopt CHASE_LINKS
# setopt POSIX_CD
setopt PUSHD_IGNORE_DUPS
# setopt PUSHD_MINUS
# setopt PUSHD_SILENT
# setopt PUSHD_TO_HOME

# Completion
# setopt ALWAYS_LAST_PROMPT
setopt ALWAYS_TO_END
# setopt AUTO_LIST
# setopt AUTO_NAME_DIRS
# setopt AUTO_PARAM_KEYS
# setopt AUTO_PARAM_SLASH
# setopt AUTO_REMOVE_SLASH
# setopt BASH_AUTO_LIST
# setopt COMPLETE_ALIASES
setopt COMPLETE_IN_WORD
# setopt GLOB_COMPLETE
# setopt HASH_LIST_ALL
# setopt LIST_AMBIGUOUS
# setopt LIST_BEEP
# setopt LIST_PACKED
# setopt LIST_ROWS_FIRST
# setopt LIST_TYPES
# setopt MENU_COMPLETE
# setopt REC_EXACT

# Expansion and Globbing
# setopt BAD_PATTERN
# setopt BARE_GLOB_QUAL
# setopt BRACE_CCL
# setopt CASE_GLOB
# setopt CASE_MATCH
# setopt CSH_NULL_GLOB
# setopt EQUALS
# setopt EXTENDED_GLOB
# setopt FORCE_FLOAT
# setopt GLOB
# setopt GLOB_ASSIGN
# setopt GLOB_DOTS
# setopt GLOB_STAR_SHORT
# setopt GLOB_SUBST
# setopt HIST_SUBST_PATTERN
# setopt IGNORE_BRACES
# setopt IGNORE_CLOSE_BRACES
# setopt KSH_GLOB
# setopt MAGIC_EQUAL_SUBST
# setopt MARK_DIRS
# setopt MULTIBYTE
# setopt NOMATCH
setopt NULL_GLOB
# setopt NUMERIC_GLOB_SORT
# setopt RC_EXPAND_PARAM
# setopt REMATCH_PCRE
# setopt SH_GLOB
# setopt UNSET
# setopt WARN_CREATE_GLOBAL
# setopt WARN_NESTED_VAR

# History
# setopt APPEND_HISTORY
# setopt BANG_HIST
setopt EXTENDED_HISTORY
# setopt HIST_ALLOW_CLOBBER
# setopt HIST_BEEP
setopt HIST_EXPIRE_DUPS_FIRST
# setopt HIST_FCNTL_LOCK
# setopt HIST_FIND_NO_DUPS
# setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
# setopt HIST_LEX_WORDS
# setopt HIST_NO_FUNCTIONS
# setopt HIST_NO_STORE
# setopt HIST_REDUCE_BLANKS
# setopt HIST_SAVE_BY_COPY
# setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
# setopt INC_APPEND_HISTORY_TIME
setopt SHARE_HISTORY

# Initialisation
# setopt ALL_EXPORT
# setopt GLOBAL_EXPORT
# setopt GLOBAL_RCS
# setopt RCS

# Input/Output
# setopt ALIASES
# setopt CLOBBER
# setopt CORRECT
# setopt CORRECT_ALL
# setopt DVORAK
setopt NO_FLOW_CONTROL
# setopt IGNORE_EOF
setopt INTERACTIVE_COMMENTS
# setopt HASH_CMDS
# setopt HASH_DIRS
# setopt HASH_EXECUTABLES_ONLY
# setopt MAIL_WARNING
# setopt PATH_DIRS
# setopt PATH_SCRIPT
# setopt PRINT_EIGHT_BIT
# setopt PRINT_EXIT_VALUE
# setopt RC_QUOTES
# setopt RM_STAR_SILENT
# setopt RM_STAR_WAIT
# setopt SHORT_LOOPS
# setopt SUN_KEYBOARD_HACK

# Job Control
# setopt AUTO_CONTINUE
# setopt AUTO_RESUME
# setopt BG_NICE
# setopt CHECK_JOBS
# setopt CHECK_RUNNING_JOBS
# setopt HUP
setopt LONG_LIST_JOBS
setopt MONITOR
# setopt NOTIFY
# setopt POSIX_JOBS

# Prompting
# setopt PROMPT_BANG
# setopt PROMPT_CR
# setopt PROMPT_SP
# setopt PROMPT_PERCENT
setopt PROMPT_SUBST
# setopt TRANSIENT_RPROMPT

# Scripts and Functions
# setopt ALIAS_FUNC_DEF
# setopt C_BASES
# setopt C_PRECEDENCES
# setopt DEBUG_BEFORE_CMD
# setopt ERR_EXIT
# setopt ERR_RETURN
# setopt EVAL_LINENO
# setopt EXEC
# setopt FUNCTION_ARGZERO
# setopt LOCAL_LOOPS
# setopt LOCAL_OPTIONS
# setopt LOCAL_PATTERNS
# setopt LOCAL_TRAPS
# setopt MULTI_FUNC_DEF
setopt MULTIOS
# setopt OCTAL_ZEROES
# setopt PIPE_FAIL
# setopt SOURCE_TRACE
# setopt TYPESET_SILENT
# setopt VERBOSE
# setopt XTRACE

# Shell Emulation
# setopt APPEND_CREATE
# setopt BASH_REMATCH
# setopt BSD_ECHO
# setopt CONTINUE_ON_ERROR
# setopt CSH_JUNKIE_HISTORY
# setopt CSH_JUNKIE_LOOPS
# setopt CSH_JUNKIE_QUOTES
# setopt CSH_NULLCMD
# setopt KSH_ARRAYS
# setopt KSH_AUTOLOAD
# setopt KSH_OPTION_PRINT
# setopt KSH_TYPESET
# setopt KSH_ZERO_SUBSCRIPT
# setopt POSIX_ALIASES
# setopt POSIX_ARGZERO
# setopt POSIX_BUILTINS
# setopt POSIX_IDENTIFIERS
# setopt POSIX_STRINGS
# setopt POSIX_TRAPS
# setopt SH_FILE_EXPANSION
# setopt SH_NULLCMD
# setopt SH_OPTION_LETTERS
# setopt SH_WORD_SPLIT
# setopt TRAPS_ASYNC

# Shell State
setopt INTERACTIVE
setopt LOGIN
# setopt PRIVILEGED
# setopt RESTRICTED
# setopt SHIN_STDIN
# setopt SINGLE_COMMAND

# Zle
# setopt BEEP
# setopt COMBINING_CHARS
# setopt EMACS
# setopt OVERSTRIKE
# setopt SINGLE_LINE_ZLE
# setopt VI
setopt ZLE

autoload -Uz zmv

autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

export ZLE_RPROMPT_INDENT=0

#=======================================================================#
# variables, sources, aliases                                           #
#=======================================================================#

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=50000
export SAVEHIST=10000

export SH="zsh"

if [ -L "${(%):-%N}" ]; then
  export DOTZSHRC=$(readlink "${(%):-%N}")
else
  export DOTZSHRC="${(%):-%N}"
fi

export ZSH_DIR="${DOTZSHRC%/*}"
export DOTFILES_HOME="${ZSH_DIR%/*/*}"

if [ -f "$DOTFILES_HOME/.env" ]; then
  source "$DOTFILES_HOME/.env"
fi

alias cp="nocorrect cp"
alias man="nocorrect man"
alias mkdir="nocorrect mkdir"
alias mv="nocorrect mv"
alias sudo="nocorrect sudo"

alias history="history -i"

#=======================================================================#
# compinit                                                              #
#=======================================================================#

# https://gist.github.com/ctechols/ca1035271ad134841284
# https://carlosbecker.com/posts/speeding-up-zsh
function zsh-compinit() {
  autoload -Uz compinit

  if [ $(date +'%j') != $(stat -f '%Sm' -t '%j' "$HOME/.zcompdump") ]; then
    compinit
  else
    compinit -C
  fi
}

#=======================================================================#
# plugin manager                                                        #
#=======================================================================#

export ZSH_PLUGIN_MANAGER="zinit"
source "$ZSH_DIR/$ZSH_PLUGIN_MANAGER.zshrc"

#=======================================================================#
# zsh profiling                                                         #
#=======================================================================#

if [ "$ZSH_PROFILING" = true ]; then
  zprof
fi

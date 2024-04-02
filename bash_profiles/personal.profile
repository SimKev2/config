#! /bin/bash

# Disable Mouse accel
# xset m 1/1 0

#-------------------
# Global Definitions
#-------------------
GREEN='\[\033[01;32m\]'
BLUE='\[\033[01;34m\]'

RESET='\[\033[00m\]'

#-------------------
# Terminal Settings
#-------------------
export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;1m\]\u\[\033[00m\]@\h: \w\[\033[01;32m\]$(parse_git_branch)\[\033[00m\] \[\033[01;34m\]$(kubectl_context)\[\033[00m\]\n$ '
export PS2='$ '

bind 'set mark-symlinked-directories on'
set mark-symlinked-directories on

export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!{.git/*,node_modules/*,vendor/*,**/*.un~}" 2> /dev/null'

#-------------------
# Aliases
#-------------------
alias grep="grep --color=auto"
alias ls="ls --color=auto"

#-----------------------------------------------------------------------------
# Functions
#-----------------------------------------------------------------------------

function cb() {
    print_code "git checkout -b $1 ${2:-upstream/master}";
    git checkout -b "$1" "${2:-upstream/master}"
}

source $HOME/.local/bin/wacomtabletmap

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

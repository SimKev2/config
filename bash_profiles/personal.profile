#! /bin/bash

# Disable Mouse accel
xset m 1/1 0

#-------------------
# Global Definitions
#-------------------
GREEN='\[\033[01;32m\]'
BLUE='\[\033[01;34m\]'

RESET='\[\033[00m\]'

#-------------------
# Terminal Settings
#-------------------
export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]: \[\033[01;34m\]\w\[\033[00m\]\[\033[01;32m\]$(parse_git_branch)\[\033[00m\] \n$ '
export PS2='$ '

bind 'set mark-symlinked-directories on'
set mark-symlinked-directories on

#-------------------
# Aliases
#-------------------
alias grep="grep --color=auto"
alias ls="ls --color=auto"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

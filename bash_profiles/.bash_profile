#-----------------------------------------------------------------------------
# Gobal definitions
#-----------------------------------------------------------------------------
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"

BOLD="\e[1m"
RESET="\e[0m"


#-----------------------------------------------------------------------------
# Terminal and ENV settings
#-----------------------------------------------------------------------------
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
export VISUAL=nvim
export EDITOR="$VISUAL"
export PYENV_ROOT="/Users/kevinsimons/.pyenv"

# Terminal Prompt
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="${BOLD}\u${RESET}@\h: \w${GREEN}\$(parse_git_branch)${RESET} \n| => "
export PS2="| => "


#-----------------------------------------------------------------------------
# Helper Functions
#-----------------------------------------------------------------------------
print_code() {
  printf "${CYAN}$1${RESET}\n"
}


#-----------------------------------------------------------------------------
# Aliases
#-----------------------------------------------------------------------------
alias ll="ls -al"
alias 🔥="echo 'RUN FIRE'"


# Virtualenv Wrapper Aliases
function lsvirtualenv() {
    ll ~/envs | awk '{print $9}' | grep '^[^\.]' | grep -Ev 'bin|lib|include'
}

function mkvirtualenv() {
    virtualenv ${2:---python=python2.7} ~/envs/$1
    source ~/envs/$1/bin/activate
}

function rmvirtualenv() {
    rm -rf ~/envs/${1:-testenv}
}

function workon() {
    source ~/envs/$1/bin/activate
}


# Git aliases
alias b="git branch"
alias cb="git checkout -b"
alias gs="git status"
alias gupdate="git fetch --all --prune"
alias gamend="git add -A && git commit --amend"

function blame() {
  print_code "git-guilt HEAD~$1"
  git-guilt HEAD~"$1";
}
alias blame="blame"


#-----------------------------------------------------------------------------
# Setup Environment
#-----------------------------------------------------------------------------
source "$HOME/tools/config/bash_profiles/work.profile"
# source "$HOME/tools/config/bash_profiles/personal.profile"

[ -f ~/git-completion.bash ] && source ~/git-completion.bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

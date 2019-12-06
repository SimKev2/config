#-----------------------------------------------------------------------------
# Global definitions
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
if [[ -e $HOME/config/shell ]]; then
  BASE16_SHELL=$HOME/config/shell/base16-shell/
  [ -n "$PS1" ] && [ -s "$BASE16_SHELL"/profile_helper.sh ] && eval "$("$BASE16_SHELL"/profile_helper.sh)"
else
  echo "No shell configs";
fi

export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
export VISUAL=nvim
export EDITOR="$VISUAL"

# Set up pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# Set up golang paths
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin:$HOME/.pub-cache/bin"

# Set up rust source
export PATH="$HOME/.cargo/bin:$PATH"
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"

# GAE sdk setup
export GAE_PREFIX=~/google-cloud-sdk/platform/google_appengine

# NVM setup
export NVM_DIR="$HOME/.nvm"

# Terminal Prompt
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Put kubectl context on PS1
export SHOW_KUBE_CONTEXT=0
kubectl_context() {
  if [ "$SHOW_KUBE_CONTEXT" = "1" ]; then
    grep current-context < ~/.kube/config | awk '{print $2}'
  fi
}

# Helper to add icon on PS1 if in minikube docker daemon
determine_minikube() {
  if [[ -z "${DOCKER_HOST}" ]]; then
    echo ""
  else
    echo " ☸"
  fi
}

# Terminal Prompt
export PS1="${BOLD}\\u${RESET}@\\h:\$(determine_minikube) \\w${GREEN}\$(parse_git_branch)${RESET} ${BLUE}\$(kubectl_context)${RESET}\\n$ "
export PS2="$ "


#-----------------------------------------------------------------------------
# Helper Functions
#-----------------------------------------------------------------------------
print_code() {
  printf "${CYAN}%s${RESET}\\n" "$1"
}


#-----------------------------------------------------------------------------
# Aliases
#-----------------------------------------------------------------------------
alias ll="ls -al"
alias 🔥="echo 'RUN FIRE'"

# Git aliases
alias b="git branch"
alias gs="git status"
alias gupdate="git fetch --all --prune"
alias gamend="git add -A && git commit --amend"

alias k="kubectl"

# Virtualenv Wrapper Aliases
_virtualEnvsComplete()
{
    local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $(compgen -W "$(ls ~/envs)" -- $cur) )
}
function lsvirtualenv() {
    ll -H ~/envs | awk '{print $9}' | grep '^[^\.]' | grep -Ev 'bin|lib|include'
}
function mkvirtualenv() {
    virtualenv "${2:---python=python3}" ~/envs/"$1"
    # shellcheck source=/dev/null
    source ~/envs/"$1"/bin/activate
}
function rmvirtualenv() {
    rm -rf ~/envs/"${1:-testenv}"
}
function workon() {
    # shellcheck source=/dev/null
    source ~/envs/"$1"/bin/activate
}
function wa() {
    cd ~/workspace/"$1" || exit 1
    workon "$1"
}

complete -F _virtualEnvsComplete rmvirtualenv
complete -F _virtualEnvsComplete workon
complete -F _virtualEnvsComplete wa

# Add kube context to PS1
function show_kube_context () {
    export SHOW_KUBE_CONTEXT=1
}


#-----------------------------------------------------------------------------
# Setup Environment
#-----------------------------------------------------------------------------
case "$OSTYPE" in
  darwin*) source "$HOME/config/bash_profiles/work.profile" ;;
  linux*) source "$HOME/config/bash_profiles/personal.profile" ;;
  *) echo "Unknown os : $OSTYPE" ;;
esac

# Load setup scripts
eval "$(pyenv init -)"
[ -f ~/git-completion.bash ] && source ~/git-completion.bash
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
# eval "$(nodenv init -)"

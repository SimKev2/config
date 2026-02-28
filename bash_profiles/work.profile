if [ -f /usr/local/etc/bash_completion ]; then
    source /usr/local/etc/bash_completion
    if [ -f '/Users/kevinsimons/.kube/completion.bash.inc' ]; then source '/Users/kevinsimons/.kube/completion.bash.inc'; fi
fi

if [ -f /Users/kevinsimons/.bash_git ]; then
  source /Users/kevinsimons/.bash_git
fi

export BASH_SILENCE_DEPRECATION_WARNING=1
export GPG_TTY=$(tty)
#export KUBECONFIG="/Users/kevinsimons/.kube/config"
#export GOPRIVATE="github.com/Workiva/*,github.com/kevinsimons-wf/*"
if [ -f '/usr/local/kubebuilder/bin/kubebuilder' ]; then export PATH=$PATH:/usr/local/kubebuilder/bin; fi

if [ -f '/opt/homebrew/opt/grep/libexec/gnubin/grep' ]; then export PATH="/opt/homebrew/opt/grep/libexec/gnubin:$PATH"; fi

if [ -f '/Users/kevinsimons/.creds/bash_env.sh' ]; then source '/Users/kevinsimons/.creds/bash_env.sh'; fi

if [ -f '/Users/kevinsimons/.krew/bin/kubectl-krew' ]; then export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"; fi

#export NPM_CONFIG__AUTH=$(echo -n "$ARTIFACTORY_PRO_USER:$ARTIFACTORY_PRO_PASS" | base64)
#export NPM_CONFIG_ALWAYS_AUTH=true
#export NPM_CONFIG_REGISTRY=https://workivaeast.jfrog.io/workivaeast/api/npm/npm-prod/

#-----------------------------------------------------------------------------
# Aliases
#-----------------------------------------------------------------------------
alias crs='~/envs/sandbox/bin/python ~/workspace/scripts/code_reviews.py'
alias assigned-prs='open https://github.com/pulls/mentioned'
alias fedaws='aws-vault exec govcloud-dev -- '

#-----------------------------------------------------------------------------
# Functions
#-----------------------------------------------------------------------------

function cb() {
    print_code "git checkout -b $1 ${2:-upstream/main}";
    git checkout -b "$1" "${2:-upstream/main}"
}

# Checkout Branch Issue - checks out a branch for the given issue on the current
# git repository. Branch name is setup for the `gh-open` script.
function cbi() {
    DIR_NAME=${PWD##*/}
    DIR_NAME=${DIR_NAME:-/}
    DIR_NAME="${DIR_NAME^^}"
    print_code "git checkout -b "${DIR_NAME}-$1" ${2:-upstream/main}";
    git checkout -b "${DIR_NAME}-$1" ${2:-upstream/main}
}

function cbpr() {
    # use as `cbpr https://github.com/grafana/<repo>/pull/<pull ID>`
    prId="${1##*/}" # prId=<pull ID>
    print_code "git fetch upstream pull/$prId/head:pr-$prId"
    git fetch upstream pull/$prId/head:pr-$prId
    print_code "git checkout pr-$prId"
    git checkout pr-$prId
}

function new-day() {
    orig_dir=$(pwd);
    projects=$(ll ~/workspace | awk '{print $9}' | grep '^[^\._]');
    for dir in $projects;
    do
        if [[ -d "$HOME/workspace/$dir/.git" ]]; then
            print_code "gupdate $dir";
            cd ~/workspace/"$dir" && git fetch --all --prune;
            echo;
        fi;
    done;
    cd "$orig_dir" || exit
}

function ssh-switch() {
    ssh-add -D;
    if [ "$1" = "work" ]; then
        ssh-add ~/.ssh/id_rsa_kevinsimons-wf;
    fi;
    if [ "$1" = "school" ]; then
        ssh-add ~/.ssh/id_rsa_school;
    fi;
    if [ "$1" = "personal" ]; then
        ssh-add ~/.ssh/id_rsa_simkev;
    fi
}

function sync() {
    print_code "git co ${1:-main}"
    git co "${1:-main}"
    print_code "gupdate"
    gupdate
    print_code "git pull"
    git pull
    # print_code "git push simkev2 ${1:-main}"
    # git push simkev2 "${1:-main}"
}

function pr() {
    githubPath=$(git remote -v | awk '/^upstream.*push.$/ { split($2, a, ":"); sub(".git$", "", a[2]); print a[2]; }');
    localBranch=$(git rev-parse --abbrev-ref HEAD);
    open "https:github.com/$githubPath/compare/main...simkev2:$localBranch?expand=1"
}

function gproj() {
    # Usage: gproj <repo name>
    cd ~/workspace || return;
    git clone git@github.com:grafana/"$1".git;
    cd "$1" || return;
    git remote rename origin upstream;
    echo "Checking simkev2 remote"
    if git ls-remote --heads git@github.com:simkev2/"$1".git; then
        git remote add simkev2 git@github.com:simkev2/"$1".git;
    fi
    gupdate;
}

function goproj() {
    # Usage: goproj <repo name>
    cd ~/go/src/github.com/grafana || return;
    git clone git@github.com:grafana/"$1".git;
    cd "$1" || return;
    git remote rename origin upstream;
    echo "Checking simkev2 remote"
    if git ls-remote --heads git@github.com:simkev2/"$1".git; then
        git remote add simkev2 git@github.com:simkev2/"$1".git;
    fi
    gupdate;
}

function notification() {
    # Usage: notification <message>
    osascript -e 'display notification "'"$*"'"';
}

function gremote() {
    if [ "$#" -eq 0 ]; then
        git remote;
    else
        if [ "$1" == "add" ]; then
            new_url="$(git remote get-url upstream | sed -e "s/grafana/$2/")";
            print_code "git remote add $2 $new_url";
            git remote add "$2" "$new_url";
            print_code "git fetch $2";
            git fetch "$2";
        else
            if [ "$1" == "clean" ]; then
                remotes="$(git remote | grep -v "simkev2\\|upstream")";
                if [[ ! -z $remotes ]]; then
                    while read -r remote; do
                        print_code "git remote remove $remote";
                        git remote remove "$remote";
                    done <<< "$remotes";
                fi;
            else
                git remote "$@";
            fi;
        fi;
    fi
}

function gifenc() {
    if [ "$#" -ne 2 ]; then
        print_code "Usage";
        print_code "gifenc <input.file> <output.file>";
    else
        palette="/tmp/palette.png";
        filters="fps=30,scale=1080:-1:flags=lanczos";
        print_code "ffmpeg -v warning -i $1 -vf \"$filters,palettegen\" -y $palette";
        ffmpeg -v warning -i "$1" -vf "$filters,palettegen" -y "$palette";
        print_code "ffmpeg -v warning -i $1 -i $palette -lavfi \"$filters [x]; [x][1:v] paletteuse\" -y $2";
        ffmpeg -v warning -i "$1" -i "$palette" -lavfi "$filters [x]; [x][1:v] paletteuse" -y "$2";
    fi
}

function k-drain() {
    kubectl drain --delete-emptydir-data --disable-eviction --force --grace-period=1 --ignore-daemonsets ${1}
}

function pltr-tsh() {
    TARGET="sundog-production"
    if [[ "${1}" == "fedops" ]]; then
        TARGET="boonie-production"
    elif [[ "${1}" == "prod-1" ]]; then
        TARGET="fontina-production"
    fi
    tsh login --auth=ad --proxy=https://teleport-usgc-1.palantirfedstart.com:3080 "${TARGET}"
    tsh kube login --auth=ad --proxy=https://teleport-usgc-1.palantirfedstart.com:3080 "${TARGET}"
}

function gar-list() {
    gcloud artifacts docker tags list --sort-by ~tag "us-docker.pkg.dev/grafanalabs-global/federal-artifacts/${1}"
}

export PATH="$PATH:$HOME/.gem/ruby/3.0.0/bin"
if [ -f '/usr/local/bin/rbenv' ]; then eval "$(rbenv init -)"; fi
export PATH="/usr/local/opt/curl/bin:$PATH"
export PATH="/Users/kevinsimons/.wk/bin:$PATH"
export PATH="/Users/kevinsimons/.local/bin:$PATH"
export BASH_SILENCE_DEPRECATION_WARNING=1
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
UNAME_MACHINE=$(/usr/bin/uname -m)
if [[ "$UNAME_MACHINE" == "arm64" ]]
then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/usr/local/bin/brew shellenv)"
fi
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export JAVA_HOME="/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home/"

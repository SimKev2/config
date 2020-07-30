source /Users/kevinsimons/tools/alacritty/alacritty-completions.bash

if [ -f /usr/local/etc/bash_completion ]; then
    source /usr/local/etc/bash_completion
    if [ -f '/Users/kevinsimons/.kube/completion.bash.inc' ]; then source '/Users/kevinsimons/.kube/completion.bash.inc'; fi
fi

export KUBECONFIG="/Users/kevinsimons/.kube/config:/Users/kevinsimons/workspace/EKS/kubeconfigs.yaml"
export GOPRIVATE="github.com/Workiva/*,github.com/kevinsimons-wf/*"

source /Users/kevinsimons/.creds/bash_env.sh

#-----------------------------------------------------------------------------
# Aliases
#-----------------------------------------------------------------------------
alias crs='~/envs/sandbox/bin/python ~/workspace/scripts/code_reviews.py'
alias assigned-prs='open https://github.com/pulls/mentioned'

#-----------------------------------------------------------------------------
# Functions
#-----------------------------------------------------------------------------

function cb() {
    print_code "git checkout -b $1 ${2:-upstream/master}";
    git checkout -b "$1" "${2:-upstream/master}"
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
    print_code "git co $1"
    git co "$1"
    print_code "git pull upstream $1"
    git pull upstream "$1"
    print_code "git push kevinsimons-wf $1"
    git push kevinsimons-wf "$1"
}

function pr() {
    githubPath=$(git remote -v | awk '/^upstream.*push.$/ { split($2, a, ":"); sub(".git$", "", a[2]); print a[2]; }');
    localBranch=$(git rev-parse --abbrev-ref HEAD);
    open "https:github.com/$githubPath/compare/master...kevinsimons-wf:$localBranch?expand=1"
}

function gproj() {
    # Usage: gproj <repo name>
    cd ~/workspace || return;
    git clone git@github.com:Workiva/"$1".git;
    cd "$1" || return;
    git remote rename origin upstream;
    echo "Checking kevinsimons-wf remote"
    if git ls-remote --heads git@github.com:kevinsimons-wf/"$1".git; then
        git remote add kevinsimons-wf git@github.com:kevinsimons-wf/"$1".git;
    fi
    gupdate;
}

function goproj() {
    # Usage: goproj <repo name>
    cd ~/go/src/github.com/Workiva || return;
    git clone git@github.com:Workiva/"$1".git;
    cd "$1" || return;
    git remote rename origin upstream;
    echo "Checking kevinsimons-wf remote"
    if git ls-remote --heads git@github.com:kevinsimons-wf/"$1".git; then
        git remote add kevinsimons-wf git@github.com:kevinsimons-wf/"$1".git;
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
            new_url="$(git remote get-url upstream | sed -e "s/Workiva/$2/")";
            print_code "git remote add $2 $new_url";
            git remote add "$2" "$new_url";
            print_code "git fetch $2";
            git fetch "$2";
        else
            if [ "$1" == "clean" ]; then
                remotes="$(git remote | grep -v "kevinsimons-wf\\|upstream")";
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

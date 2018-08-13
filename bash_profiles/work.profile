source /Users/kevinsimons/tools/alacritty/alacritty-completions.bash

#-----------------------------------------------------------------------------
# Aliases
#-----------------------------------------------------------------------------
alias crs='~/envs/sandbox/bin/python ~/workspace/scripts/code_reviews.py'
alias assigned-prs='open https://github.com/pulls/mentioned'

#-----------------------------------------------------------------------------
# Functions
#-----------------------------------------------------------------------------

function cb() {
    print_code "git checkout -b $1 ${2:-kevinsimons-wf/master}";
    git checkout -b "$1" "${2:-kevinsimons-wf/master}"
}

function localsky() {
  sky
  cd skynet
  print_code "python /usr/local/google_appengine/dev_appserver.py --port 8083 --host localhost --datastore_path=/Users/kevinsimons/tools/skynet-datastore/datastore.db --admin_port=8082 ."

  python /usr/local/google_appengine/dev_appserver.py --port 8083 --host localhost --datastore_path=/Users/kevinsimons/tools/skynet-datastore/datastore.db --admin_port=8082 .
}

function new-day() {
    orig_dir=$(pwd);
    projects=$(ll ~/workspace | awk '{print $9}' | grep '^[^\._]');
    for dir in $projects;
    do
        if [[ -d "$HOME/workspace/$dir/.git" ]]; then
            print_code "gupdate $dir";
            cd ~/workspace/$dir && git fetch --all --prune;
            echo;
        fi;
    done;
    cd $orig_dir
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

function rapi() {
    wa skynet;
    cd skynet;
    appspot=wf-skynet-staging;
    server=$appspot.appspot.com;
    if [ $# -gt 0 ]; then
        appspot="$1";
        server=$appspot.appspot.com;
    fi;
    if [ "$1" = 'localhost' ]; then
        appspot='';
        server='localhost:8083';
    fi;
    print_code "remote_api_shell.py -s $server";
    remote_api_shell.py -s $server;
    cd ..
}

function pr() {
    githubPath=$(git remote -v | awk '/^upstream.*push.$/ { split($2, a, ":"); sub(".git$", "", a[2]); print a[2]; }');
    localBranch=$(git rev-parse --abbrev-ref HEAD);
    open "https:github.com/$githubPath/compare/master...kevinsimons-wf:$localBranch?expand=1"
}

function gproj() {
    # Usage: gproj <repo name>
    cd ~/workspace || exit;
    git clone git@github.com:Workiva/"$1".git;
    cd "$1" || exit;
    git remote rename origin upstream;
    git remote add kevinsimons-wf git@github.com:kevinsimons-wf/"$1".git;
    gupdate;
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

#!/bin/bash

export BRANCH="${1}"
function ask_user() {
    echo -n "$1 "
    read -r answer </dev/tty
    [[ ${answer,,} == "y" ]]
}
function download() {
    if ! [[ -v DOWNLOADED ]]; then
        TMP_DIR="$(mktemp -d /tmp/dotfilesXXXXXXXXXXXXXXXXXXXXXXXXX)"
        cd "${TMP_DIR}" && if wget "https://github.com/daniele821/dotfiles/archive/${BRANCH}.zip"; then
            unzip ./*.zip
            rm ./*.zip
            mv ./* dotfiles
        else
            echo "${BRANCH} is not a valid branch!"
        fi
        export DOWNLOADED=
    fi
}
function run_init() {
    download
    ./dotfiles/autosaver run
}
function run_git() {
    ask_user "Please add ssh keys to github, then press enter to continue..."
    download
    git clone git@daniele821.github.com:daniele821/dotfiles.git "$(mktemp -d /tmp/fix-ssh-keyXXXXXXXXXXXXXXXXX)"
    ./dotfiles/scripts/git_repos/restore_git_repos.sh
}
function run_reboot() {
    ask_user "Are you REALLY REALLY sure you want to reboot?" && reboot
}

if [[ "$#" -gt 1 ]]; then
    for word in "$@"; do
        [[ "$word" == "init" ]] && export RUN_INIT=y
        [[ "$word" == "git" ]] && export RUN_GIT=y
        [[ "$word" == "reboot" ]] && export RUN_REBOOT=y
    done
fi

if [[ "$#" -gt 1 ]]; then
    [[ "${RUN_INIT}" == "y" ]] && run_init
    [[ "${RUN_GIT}" == "y" ]] && run_git
    [[ "${RUN_REBOOT}" == "y" ]] && run_reboot
else
    [[ -z "${BRANCH}" ]] && read -p "Write branch name: " -r branch </dev/tty && BRANCH="$branch"
    ask_user "Do you really want to run init scripts?" && run_init
    ask_user "Do you really want to download git repos?" && run_git
    ask_user "Do you really want to reboot?" && run_reboot
fi

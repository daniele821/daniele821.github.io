#!/bin/bash

{
    {
        date "+waiting for connection: %H:%m:%S:%N"
        nm-online
        date "+connection resolved (or failed): %H:%m:%S:%N"
        /personal/repos/daniele821/dotfiles/scripts/git_repos/update_git_repos.sh
        date "+git repos updated: %H:%m:%S:%N"
    } >/tmp/GIT_UPDATES.out &

    # add more startups here

} &>/dev/null

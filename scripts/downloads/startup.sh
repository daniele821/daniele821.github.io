#!/bin/bash

{
    {
        date "+waiting for connection: %H:%m:%S:%N"
        if nm-online; then
            date "+connection resolved: %H:%m:%S:%N"
            /personal/repos/daniele821/dotfiles/scripts/git_repos/update_git_repos.sh
            date "+git repos updated: %H:%m:%S:%N"
        else
            date "+connection failed: %H:%m:%S:%N"
        fi
    } >/tmp/GIT_UPDATES.out &

    # add more startups here

} &>/dev/null

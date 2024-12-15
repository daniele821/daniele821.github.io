#!/bin/bash

[[ "$#" == "0" ]] && echo 'write the branch you want to download' && exit 1

TMP_DIR="$(mktemp -d /tmp/dotfilesXXXXXXXXXXXXXXXXXXXXXXXXX)"
cd "${TMP_DIR}" && if wget "https://github.com/daniele821/dotfiles/archive/${1}.zip"; then
    unzip ./*.zip
    rm ./*.zip
    mv ./* dotfiles
    ./dotfiles/autosaver run
else
    echo "${1} is not a valid branch!"
fi

#!/bin/bash

TMP_DIR="$(mktemp -d)" &&
    git clone --branch fedora-kde --depth 1 "https://github.com/daniele821/dotfiles" "$TMP_DIR" &&
    "$TMP_DIR/run/03_gitrepos.sh"

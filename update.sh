#!/bin/bash

SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"

JSON_FILE="${SCRIPT_DIR}/scripts.json"

find "${SCRIPT_DIR}" -mindepth 2 -maxdepth 2 -type f -iname 'index.html' |
    while read -r path; do
        dir="$(dirname "$path")"
        update_path="$dir/update.sh"
        favicon_path="$dir/images/favicon.png"
        name="$(basename "$dir")"
        name="${name^}"
        echo $path, $dir, $update_path, $favicon_path, $name
    done

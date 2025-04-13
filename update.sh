#!/bin/bash

SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"

JSON_FILE="${SCRIPT_DIR}/scripts.json"

INDEX=0

echo "[" >"$JSON_FILE"
find "${SCRIPT_DIR}" -mindepth 2 -maxdepth 2 -type f -iname 'index.html' | sort |
    while read -r path; do
        [[ "$INDEX" -ge 1 ]] && echo "," >>"$JSON_FILE"
        dir="$(dirname "$path")"
        name="$(basename "$dir")"
        update_path="$dir/update.sh"
        path="$name"
        name="${name^}"
        echo "{\"name\":\"$name\", \"url\":\"$path\"}" >>"$JSON_FILE"

        if [[ -x "$update_path" ]]; then
            echo "running script: $name"
            "$update_path"
        fi
        ((INDEX++))
    done
echo "]" >>"$JSON_FILE"

if command -v "jq" &>/dev/null; then
    TMPFILE="$(mktemp)"
    jq . "$JSON_FILE" >"$TMPFILE"
    mv "$TMPFILE" "$JSON_FILE"
fi

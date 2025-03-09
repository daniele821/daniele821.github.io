#!/bin/bash

SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"

JSON_FILE="${SCRIPT_DIR}/scripts.json"
FILE_NAMES=()

mkdir -p "${SCRIPT_DIR}/previews"
mkdir -p "${SCRIPT_DIR}/.previews_original"

for ORIGINAL in "${SCRIPT_DIR}/downloads/"*; do
    ORIGINAL_BASE="$(basename "${ORIGINAL}")"
    ORIGINAL_EXT="${ORIGINAL_BASE%.*}"
    OLD_VER="${SCRIPT_DIR}/.previews_original/$ORIGINAL_BASE"
    if ! diff -q "$ORIGINAL" "$OLD_VER" &>/dev/null; then
        nvim "${ORIGINAL}" --headless -c "TOhtml ${SCRIPT_DIR}/previews/${ORIGINAL_EXT}.html | qa"
        cp "$ORIGINAL" "$OLD_VER"
    fi
    FILE_NAMES+=("$ORIGINAL_EXT")
done

printf '%s\n' "${FILE_NAMES[@]}" | jq -R . | jq -s . >"$JSON_FILE"

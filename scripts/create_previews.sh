#!/bin/bash

SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"

JSON_FILE="${SCRIPT_DIR}/scripts.json"
FILE_NAMES=()
TMP_DIR="$(mktemp -d)"

mkdir -p "${SCRIPT_DIR}/previews"
mkdir -p "${SCRIPT_DIR}/.previews_original"

for ORIGINAL in "${SCRIPT_DIR}/downloads/"*; do
    ORIGINAL_BASE="$(basename "${ORIGINAL}")"
    ORIGINAL_EXT="${ORIGINAL_BASE%.*}"
    NEW_FILE="${SCRIPT_DIR}/previews/${ORIGINAL_EXT}.html"
    OLD_VER="${SCRIPT_DIR}/.previews_original/$ORIGINAL_BASE"
    if ! [[ -f "$NEW_FILE" ]] || ! diff -q "$ORIGINAL" "$OLD_VER" &>/dev/null; then
        nvim "${ORIGINAL}" --headless -c "TOhtml $NEW_FILE | qa"
        cp "$ORIGINAL" "$OLD_VER"
    fi
    cp "$NEW_FILE" "${TMP_DIR}/"
    FILE_NAMES+=("$ORIGINAL_EXT")
done

printf '%s\n' "${FILE_NAMES[@]}" | jq -R . | jq -s . >"$JSON_FILE"

rm -rf "${SCRIPT_DIR}/previews/"
mv "$TMP_DIR/" "${SCRIPT_DIR}/previews"

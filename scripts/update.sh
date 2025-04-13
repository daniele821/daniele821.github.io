#!/bin/bash

SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"

JSON_FILE="${SCRIPT_DIR}/scripts.json"
FILE_NAMES=()
TMP_DIR="$(mktemp -d)"
TMP_DIR2="$(mktemp -d)"

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
    cp "$OLD_VER" "${TMP_DIR2}/"
    FILE_NAMES+=("$ORIGINAL_EXT")
done

{
    echo -n "["
    if [[ ${#FILE_NAMES[@]} -gt 0 ]]; then
        echo -n "\"${FILE_NAMES[0]}\""
        for name in "${FILE_NAMES[@]:1}"; do
            echo -n ",\"${name}\""
        done
    fi
    echo "]"
} >"$JSON_FILE"

if command -v "jq" &>/dev/null; then
    TMPFILE="$(mktemp)"
    jq . "$JSON_FILE" >"$TMPFILE"
    mv "$TMPFILE" "$JSON_FILE"
fi

rm -rf "${SCRIPT_DIR}/previews/" "${SCRIPT_DIR}/.previews_original/"
mv "$TMP_DIR/" "${SCRIPT_DIR}/previews"
mv "$TMP_DIR2/" "${SCRIPT_DIR}/.previews_original/"

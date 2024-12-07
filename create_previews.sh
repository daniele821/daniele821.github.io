#!/bin/bash

SCRIPT_PWD="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PWD}")"

for ORIGINAL in "${SCRIPT_DIR}/downloads/"*; do
    ORIGINAL_BASE="$(basename "${ORIGINAL}")"
    ORIGINAL_EXT="${ORIGINAL_BASE%.*}"
    nvim "${ORIGINAL}" --headless -c "TOhtml ${SCRIPT_DIR}/previews/${ORIGINAL_EXT}.html | qa"
done

#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

SCALE=50

for image in "$SCRIPT_DIR"/*.png; do
    ffmpeg -i "$image" -vf "scale=$SCALE:$SCALE:force_original_aspect_ratio=decrease,pad=$SCALE:$SCALE:(ow-iw)/2:(oh-ih)/2:color=0x00000000" TMP.png
    mv TMP.png "$image"
done

TMP_DIR="$(mktemp -d)" &&
    git clone --branch fedora-kde --depth 1 "https://github.com/daniele821/dotfiles" "$TMP_DIR" &&
    BRANCH="" "$TMP_DIR/autosaver" git &&
    SET_BRANCH="" /personal/repos/daniele821/dotfiles &&
    rm -rf ~/.config/nvim && ln -s /personal/repos/daniele821/nvim-config ~/.config/nvim &&
    rm -rf "$TMP_DIR"

